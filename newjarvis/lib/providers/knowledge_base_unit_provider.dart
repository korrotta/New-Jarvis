import 'package:flutter/material.dart';
import 'package:newjarvis/models/unit_of_knowledgebase_model.dart';
import 'package:newjarvis/services/kbase_unit_data_source_service.dart';

class UnitProvider with ChangeNotifier {
 
  final KnowledgeBaseUnitApiService _unitApiService = KnowledgeBaseUnitApiService();
  
  String knowledgeName = '';
  String knowledgeId = '';
  String kbDescription = '';
  int numUnits = 0;

  List<Unit> unitList = [];
  List<Unit> filteredUnitList = [];
  final TextEditingController searchController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;


  UnitProvider() {
    
    //loadUnitListOfKnowledge();
    _filterUnitList();
    searchController.addListener(_filterUnitList); 
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setKnowledgeDetails({
    required String name,
    required String id,
    required String description,
    required int units,
  }) {
    knowledgeName = name;
    knowledgeId = id;
    kbDescription = description;
    numUnits = units;
    notifyListeners();
  }

  void updateKnowledgeName(String newName) {
    knowledgeName = newName;
    notifyListeners();
  }

  void _updateTotalUnits() {
    numUnits = unitList.length;
    notifyListeners();
  }

  void _filterUnitList() {
    final query = searchController.text.toLowerCase();
    filteredUnitList = unitList.where((unit) {
      return unit.name.toString().toLowerCase().contains(query);
    }).toList();
    notifyListeners();
  }

  Future<void> loadUnitListOfKnowledge() async {
  try {
    _setLoading(true);
    final fetchedUnitOfKnowledge =
    await _unitApiService.getUnitsOfKnowledge
    (
      knowledgeId: knowledgeId
    );

    unitList = fetchedUnitOfKnowledge;
    filteredUnitList = unitList;
    _setLoading(false);

  } catch (e) {
    _setLoading(false);
      print('Error fetching units: $e');
      throw Exception('Failed to load units: $e');
    }
}


  Future <void> addunitFromFileLocal(String file) async {
  try {
    final result = await _unitApiService.uploadLocalFile(
      knowledgeId: knowledgeId,
      filePath: file,
    );
    
    await loadUnitListOfKnowledge();
    _updateTotalUnits();

    print('Upload thành công: $result');
    const SnackBar(content: Text('File uploaded successfully'));

  } catch (e) {
    print('Lỗi upload file: $e');
    const SnackBar(content: Text('Failed to upload file'));
  }
}

  Future <void> addUnitFromWeb(String name, String url) async {
  try {
    // Gọi API addUnitWebsite để thêm unit
    final response = await _unitApiService.addUnitWebsite(
      knowledgeId: knowledgeId, 
      unitName: name,
      webUrl: url,
    );

    // Xử lý kết quả trả về (nếu cần)
    print('Unit added successfully: $response');

    // Thông báo thành công
    const SnackBar(content: Text('Website Unit added successfully'));
 
    await loadUnitListOfKnowledge();
    _updateTotalUnits();
    
    
  } catch (e) {
    // Xử lý lỗi khi gọi API
  const SnackBar(content: Text('Failed to add Website Unit'));
   
  }
}

  Future<void> addUnitFromSlack(String name, String workspace, String botToken) async {
  try {
    // Gọi API addSlackUnit để thêm unit
    final response = await _unitApiService.addUnitSlack(
      knowledgeId: knowledgeId, 
      unitName: name,
      slackWorkspace: workspace,
      slackBotToken: botToken,
    );

    // Xử lý kết quả trả về (nếu cần)
    print('Slack Unit added successfully: $response');

    // Thông báo thành công
    const SnackBar(content: Text('Slack Unit added successfully'));

    // Tải lại danh sách Unit (nếu cần)
    await loadUnitListOfKnowledge();
    _updateTotalUnits();

  } catch (e) {
    // Xử lý lỗi khi gọi API
    const SnackBar(content: Text('Failed to add Slack Unit'));
  }
}

  Future<void> addUnitFromConfluence(String unitName, String wikiPageUrl,
   String confluenceUsername, String confluenceAccessToken) async {

  try {
    // Gọi API addUnitConfluence để thêm unit
    final response = await _unitApiService.addUnitConfluence(
      knowledgeId: knowledgeId,
      unitName: unitName,
      wikiPageUrl: wikiPageUrl,
      confluenceUsername: confluenceUsername,
      confluenceAccessToken: confluenceAccessToken,
    );

    // Xử lý kết quả trả về (nếu cần)
    print('Confluence Unit added successfully: $response');

    // Thông báo thành công
    const SnackBar(content: Text('Confluence Unit added successfully'));

    // Tải lại danh sách Unit (nếu cần)
    await loadUnitListOfKnowledge();
    _updateTotalUnits();
    
  } catch (e) {
    // Xử lý lỗi khi gọi API
    print('Error adding Confluence Unit: $e');
    const SnackBar(content: Text('Failed to add Confluence Unit'));
  }
}

Future<void> toggleUnitStatus(String unitId, bool newStatus) async {
  try {
    _setLoading(true);
    // Gọi API để cập nhật trạng thái
    final updatedUnit = await _unitApiService.setUnitStatus(
      unitId: unitId,
      status: newStatus,
    );

    // Tìm và cập nhật trạng thái của unit trong danh sách
    final index = unitList.indexWhere((unit) => unit.id == unitId);
    if (index != -1) {
      unitList[index] = updatedUnit; // Cập nhật toàn bộ Unit từ API
      filteredUnitList = unitList; // Cập nhật danh sách đã lọc
    }

    notifyListeners(); // Thông báo cập nhật giao diện
    print("Unit status toggled successfully");
  } catch (e) {
    print("Error toggling unit status: $e");
    throw Exception('Failed to toggle unit status');
  } finally {
    _setLoading(false);
  }
}


Future<void> deleteUnit(String unitId, String knowledgeId) async {
  try {
    _setLoading(true);

    // Gọi API xóa Unit
    await _unitApiService.deleteUnit(unitId, knowledgeId);

    // Xóa unit khỏi danh sách trong Provider
    filteredUnitList.removeWhere((unit) => unit.id == unitId);

    notifyListeners(); // Cập nhật giao diện
    print("Unit deleted successfully");
  } catch (e) {
    print("Error deleting unit: $e");
    throw Exception('Failed to delete unit');
  } finally {
    _setLoading(false);
  }
}



}