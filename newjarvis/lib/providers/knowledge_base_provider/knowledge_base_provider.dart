import 'package:flutter/material.dart';
import 'package:newjarvis/models/knowledge_base/knowledge_base_model.dart';
import 'package:newjarvis/services/kbase_knowledge_service.dart';

class KnowledgeBaseProvider with ChangeNotifier{

  final KnowledgeBaseApiService _knowledgeApiService = KnowledgeBaseApiService();

  List<Knowledge> knowledgeList = [];
  List<Knowledge> filteredKnowledgeList = [];
  final TextEditingController searchController = TextEditingController();
  bool isLoading = false;

  KnowledgeBaseProvider() {
  _initialize();
}

Future<void> _initialize() async {
  await _loginKnowledgeApi();
  await loadKnowledgeList();
  _filterKnowledgeList(); 
  searchController.addListener(_filterKnowledgeList);
}

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterKnowledgeList() {
    final query = searchController.text.toLowerCase();
    
    filteredKnowledgeList = knowledgeList.where((knowledge) {
      return knowledge.name.toString().toLowerCase().contains(query);
    }).toList();
    notifyListeners();
  }

  Future<void> _loginKnowledgeApi() async {
    try {
      await _knowledgeApiService.SignInKB();
      print('Successfully logged in to the knowledge API');
    } catch (e) {
      print('Error during auto login: $e');
    }
    notifyListeners();
  }

  Future<void> loadKnowledgeList() async {

    try {

    isLoading = true; // Bật trạng thái loading
    notifyListeners();

    final fetchedKnowledge = await _knowledgeApiService.getKnowledge();

      knowledgeList = fetchedKnowledge;
      filteredKnowledgeList = knowledgeList;
      notifyListeners();
    } catch (e) {
      
      notifyListeners();
      print('Error fetching knowledge: $e');
      throw Exception('Failed to load knowledge: $e');
    }
    finally {
    isLoading = false; // Tắt trạng thái loading
    notifyListeners();
  }
  }

  void updateKnowldege(String knowledgeId, String newName, String description) async {
    try {
      await _knowledgeApiService.updateKnowledge(
        id: knowledgeId,
        knowledgeName: newName,
        description: description,
      );

      await loadKnowledgeList();
      const SnackBar(content: Text('Knowledge updated successfully'));

    } catch (e) {
      throw Exception('Failed to update knowledge: $e');
    }
  }

  void addKnowledge(String name, String description) async {
  try {
    await _knowledgeApiService.createKnowledge(
      knowledgeName: name,
      description: description,
    );

    await loadKnowledgeList();
    const SnackBar(content: Text('Knowledge created successfully'));

  } catch (e) {
      throw Exception('Failed to create knowledge: $e');
    }
}

void deleteKnowledge(String id) async {
  try {
    await _knowledgeApiService.deleteKnowledge(id);
    await loadKnowledgeList();

    const SnackBar(content: Text('Knowledge deleted successfully'));

  } catch (e) {
      throw Exception('Failed to delete knowledge: $e');
    }
  }


}