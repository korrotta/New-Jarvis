
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newjarvis/components/knowledge_base/knowledge_base_editkb.dart';
import 'package:newjarvis/components/knowledge_base/knowledge_unit_add.dart';
import 'package:newjarvis/components/knowledge_base/knowledge_unit_confluence.dart';
import 'package:newjarvis/components/knowledge_base/knowledge_unit_drive.dart';
import 'package:newjarvis/components/knowledge_base/knowledge_unit_local_file.dart';
import 'package:newjarvis/components/knowledge_base/knowledge_unit_slack.dart';
import 'package:newjarvis/components/knowledge_base/knowledge_unit_web.dart';
import 'package:newjarvis/providers/knowledge_base_provider/knowledge_base_provider.dart';
import 'package:newjarvis/providers/knowledge_base_provider/knowledge_base_unit_provider.dart';
import 'package:provider/provider.dart';


class KnowledgeUnitScreen extends StatefulWidget {
 
  const KnowledgeUnitScreen({super.key});

  @override
  State<KnowledgeUnitScreen> createState() => _KnowledgeUnitScreenState();
}

class _KnowledgeUnitScreenState extends State<KnowledgeUnitScreen> {
  

  // Show the first dialog to choose the method
  void _showAddUnitDialog() {
  FocusScope.of(context).unfocus(); 

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SelectMethodDialog(
        onMethodSelected: (selectedMethod) {
          // Chỉ mở dialog tiếp theo sau khi dialog hiện tại được đóng
          Future.delayed(Duration.zero, () {
            switch (selectedMethod) {
              case "Website":
                showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    final unitProvider = Provider.of<UnitProvider>(context, listen: false);
                    final knowledgeProvider = Provider.of<KnowledgeBaseProvider>(context, listen: false);
                    return CreateUnitDialogFromWeb(
                      onConfirm: (name, url) async{

                        try{
                        // Xử lý logic khi xác nhận từ giao diện Website
                        await unitProvider.addUnitFromWeb(name, url); 

                        // Sau khi upload file thành công, load lại danh sách knowledge
                        await knowledgeProvider.loadKnowledgeList();
               
                        if (Navigator.canPop(dialogContext)) {
                          Navigator.pop(dialogContext);
                        }
                        } catch (e) {
                          print('Lỗi upload file: $e');
                          const SnackBar(content: Text('Failed to upload file'));
                        }
                      },
                    );
                  },
                );
              break;

              case "Local Files":
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  final unitProvider = Provider.of<UnitProvider>(context, listen: false);
                  final knowledgeProvider = Provider.of<KnowledgeBaseProvider>(context, listen: false);

                  return CreateUnitDialogFromLocalFile(
                    onConfirm: (fileName) async {
                      // Đợi hàm addunitFromFileLocal hoàn tất
                      await unitProvider.addunitFromFileLocal(fileName);

                      // Sau khi upload file thành công, load lại danh sách knowledge
                      await knowledgeProvider.loadKnowledgeList();
                    },
                  );
                },
              );
              break;

              case "Google Drive":
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    
                    //final unitProvider = Provider.of<UnitProvider>(context);
                    return CreateUnitDialogFromGoogleDrive(
                      onConfirm: (name,) {
                        // Xử lý logic khi xác nhận từ giao diện Google Drive
                        //_addUnit("GG Drive", name);
                      },
                    );
                  },
                );
                break;
              case "Slack":
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    final unitProvider = Provider.of<UnitProvider>(context, listen: false);
                    final knowledgeProvider = Provider.of<KnowledgeBaseProvider>(context, listen: false);
                    return CreateUnitDialogFromSlack(
                      onConfirm: (name, workSpace, botToken) async {
                        // Xử lý logic khi xác nhận từ giao diện Slack
                        await unitProvider.addUnitFromSlack(name, workSpace, botToken);

                        // Sau khi upload file thành công, load lại danh sách knowledge
                        await knowledgeProvider.loadKnowledgeList();
                      },
                    );
                  },
                );
                break;
              case "Confluence":
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    final unitProvider = Provider.of<UnitProvider>(context, listen: false);
                    final knowledgeProvider = Provider.of<KnowledgeBaseProvider>(context, listen: false);
                    return CreateUnitDialogFromConfluence(
                      onConfirm: (name, pageUrl, userName, accessToken) async {
                        // Xử lý logic khi xác nhận từ giao diện Confluence
                        await unitProvider.addUnitFromConfluence(name, pageUrl, userName, accessToken);

                        // Sau khi upload file thành công, load lại danh sách knowledge
                        await knowledgeProvider.loadKnowledgeList();
                      },
                    );
                  },
                );
                break;
              default:
                print("Unsupported method selected: $selectedMethod");
            }
          });
        },
      );
    },
  );
}

Color _getBackgroundColor(String unitName) {
  switch (unitName) {
    case "local_file":
      return Colors.grey.shade700;
    case "web":
      return Colors.brown;
    case "drive":
      return const Color.fromARGB(255, 123, 200, 100); 
    case "slack":
      return Colors.purple.shade700; 
    case "confluence":
      return const Color.fromARGB(216, 43, 34, 170); 
    default:
      return Colors.grey.shade300; 
  }
}

// Hàm trả về logo dựa trên loại nguồn
String _getLogoAsset(String type) {
  switch (type.toLowerCase()) {
    case 'local_file':
      return 'assets/icons/iconLocalfile.png';
    case 'confluence':
      return 'assets/icons/iconConfluence.png';
    case 'slack':
      return 'assets/icons/iconSlack.png';
    case 'web':
      return 'assets/icons/iconWeb.png';
    case 'drive':
      return 'assets/icons/iconDrive.png';
    default:
      return 'assets/icons/iconLocalfile.png';
  }
}

String formatSize(int bytes) {
  if (bytes >= 1000000000) {
    // Lớn hơn hoặc bằng 1 GB
    return '${(bytes / 1000000000).toStringAsFixed(2)} GB';
  } else if (bytes >= 1000000) {
    // Lớn hơn hoặc bằng 1 MB
    return '${(bytes / 1000000).toStringAsFixed(2)} MB';
  } else if (bytes >= 1000) {
    // Lớn hơn hoặc bằng 1 KB
    return '${(bytes / 1000).toStringAsFixed(2)} KB';
  } else {
    // Dưới 1 KB, hiển thị nguyên byte
    return '$bytes bytes';
  }
}


String formatDate(String isoDate) {
  try {
    final DateTime dateTime = DateTime.parse(isoDate);
    return DateFormat('dd-MM-yyyy HH:mm:ss').format(dateTime); 
  } catch (e) {
    return isoDate; // Trả về nguyên nếu lỗi
  }
}




  @override
  Widget build(BuildContext context) {

    final unitProvider = Provider.of<UnitProvider>(context);
    final knowldegeProvider = Provider.of<KnowledgeBaseProvider>(context);
    //final unitList = unitProvider.unitList;
    final filteredUnitList = unitProvider.filteredUnitList;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Knowledge Unit',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Times New Roman',
          ),
        ),
        backgroundColor: Colors.grey.shade200,
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // Header Container with Knowledge Name and Unit Count
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color:  Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
              color: Colors.black, 
              width: 1.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Knowledge: ${unitProvider.knowledgeName}',
                        style: const TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.black),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return EditKnowledgeDialog(
                            kbName: unitProvider.knowledgeName,
                            kbDescription: unitProvider.kbDescription,
                            onConfirm: (newName, description) async {
                         
                              // Gọi API để cập nhật knowledge
                            knowldegeProvider.updateKnowldege(unitProvider.knowledgeId, newName, description);
                              
                            // Cập nhật lại name hiển thị trong Container
                            unitProvider.updateKnowledgeName(newName);
                            //knowldegeProvider.loadKnowledgeList();
                            
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
                //const SizedBox(height: 5.0),
                Text(
                  'Total Units: ${unitProvider.numUnits}',
                  style: const TextStyle(
                    fontSize: 13.0,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 9.0),
              ],
            ),
          ),

            const SizedBox(height: 16.0),
            // Search Bar
            TextField(
              controller: unitProvider.searchController,
              decoration: InputDecoration(
                hintText: 'Search Units',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0.0,
                  horizontal: 16.0,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            // Add Unit Button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: _showAddUnitDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade800,
                ),
                icon: const Icon(
                  Icons.add,  
                  color: Colors.white,
                ),
                label: const Text(
                  'Add Unit',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 8.0),
            
            // List of Units
                      // Units List
            Expanded(
            child: filteredUnitList.isEmpty
                ? const Center(
                    child: Text(
                      'No units found. Click "Add Unit" to add one.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16.0),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredUnitList.length,
                    itemBuilder: (context, index) {
                      final unit = filteredUnitList[index];
                      return Column(
                        children: [
                          Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              side: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1.0,
                              ),
                            ),
                            elevation: 3.0,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Logo Section (Cố định độ rộng)
                                  SizedBox(
                                    width: 60, // Đảm bảo kích thước cố định
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          _getLogoAsset(unit.type),
                                          width: 35,
                                          height: 40,
                                          fit: BoxFit.contain,
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          formatSize(unit.size),
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          unit.type,
                                          style: const TextStyle(
                                            fontSize: 11.5,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 20),

                                  // Unit Information Section (Expand để chiếm phần giữa)
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          unit.name,
                                          style: const TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 23),
                                        Text(
                                          'Create: ${formatDate(unit.createdAt)}', 
                                          style: const TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          'Update: ${formatDate(unit.updatedAt)}', 
                                          style: const TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Actions Section (Cố định độ rộng)
                                  SizedBox(
                                    width: 80, // Đảm bảo kích thước cố định
                                    child: Column(
                                      children: [
                                        // Enable Toggle Button
                                          Transform.scale(
                                          scale: 0.7, // Điều chỉnh tỷ lệ (1.0 là kích thước mặc định, nhỏ hơn là giảm kích thước)
                                          child: Switch(
                                            value: unit.status,
                                            onChanged: (value) async {
                                              await unitProvider.toggleUnitStatus(unit.id, value);
                                            },
                                            activeColor: Colors.blueAccent,
                                            inactiveThumbColor: Colors.red,
                                          ),
                                        ),

                                        const SizedBox(height: 10),
                                        // Delete Button
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.black54,
                                          ),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                final knowledgeProvider = Provider.of<KnowledgeBaseProvider>(context, listen: false);
                                                return AlertDialog(
                                                  title: const Text('Delete Confirmation'),
                                                  content: const Text(
                                                      'Are you sure you want to delete this unit?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: const Text(
                                                        'Cancel',
                                                        style: TextStyle(color: Colors.black),
                                                      ),
                                                    ),
                                                    ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.red,
                                                      ),
                                                      onPressed: () async {
                                                        Navigator.of(context).pop();
                                                        await unitProvider.deleteUnit(
                                                            unit.id, unit.knowledgeId);
                                                        
                                                        await knowledgeProvider.loadKnowledgeList();
                                                      },
                                                      child: const Text(
                                                        'Delete',
                                                        style: TextStyle(color: Colors.white),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Divider
                          if (index < filteredUnitList.length - 1)
                          Divider(
                            color: Colors.grey.shade400,
                            height: 1.0,
                            thickness: 1.0,
                          ),
                        ],
                      );
                    },
                  ),
              ),
          ],
        ),
      ),
    );
  }
}

