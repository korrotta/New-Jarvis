
import 'package:flutter/material.dart';
import 'package:newjarvis/pages/kbase_unit_add_method.dart';
import 'package:newjarvis/pages/kbase_unit_confluence.dart';
import 'package:newjarvis/pages/kbase_unit_edit_kb.dart';
import 'package:newjarvis/pages/kbase_unit_ggdrive.dart';
import 'package:newjarvis/pages/kbase_unit_local_file.dart';
import 'package:newjarvis/pages/kbase_unit_slack.dart';
import 'package:newjarvis/pages/kbase_unit_web.dart';
import 'package:newjarvis/providers/knowledge_base_provider.dart';
import 'package:newjarvis/providers/knowledge_base_unit_provider.dart';
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
                        // Xử lý logic khi xác nhận từ giao diện Website
                        unitProvider.addUnitFromWeb(name, url);

                        // Sau khi upload file thành công, load lại danh sách knowledge
                        await knowledgeProvider.loadKnowledgeList();
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
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 4.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: BorderSide(
                          color: Colors.grey.shade700,
                          width: 1.0,
                        ),
                      ),
                      elevation: 6.0,
                      child: Column(
                        children: [
                          // Top Section with File Name
                          Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: _getBackgroundColor(unit.type),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12.0),
                              topRight: Radius.circular(12.0),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.insert_drive_file_outlined, 
                                color: Colors.white,     
                              ),
                              const SizedBox(width: 5), 
                              Text(
                                unit.name,
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),


                        // Bottom Section with Attributes
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 12.0,
                          ),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12.0),
                              bottomRight: Radius.circular(12.0),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Source
                              Row(
                                children: [
                                  const Text(
                                    "Source: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.0
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      unit.type,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 13.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5.0),
                              // Size
                              Row(
                                children: [
                                  const Text(
                                    "Size: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.0
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${unit.size}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 13.0
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5.0),
                              // Create Time
                              Row(
                                children: [
                                  const Text(
                                    "Create Time: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.0
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      unit.createdAt,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 13.0
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5.0),
                              // Latest Update
                              Row(
                                children: [
                                  const Text(
                                    "Latest Update: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.0
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      unit.updatedAt,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 13.0
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5.0),
                              // Enable Button
                              Row(
                                children: [
                                  const Text(
                                    "Status: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.0
                                    ),
                                  ),
                                  Text(
                                    unit.status ? "Enabled" : "Disabled",
                                    style: TextStyle(
                                      color: unit.status
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  const Spacer(),
                                  // Enable Toggle Button
                                  Switch(
                                    value: unit.status,
                                    onChanged: (value) async{
                                      await unitProvider.toggleUnitStatus(unit.id, value);
                                    },
                                    activeColor: Colors.green,
                                    inactiveThumbColor: Colors.red,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Delete Button
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.black54),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Delete Confirmation'),
                                    content: const Text(
                                        'Are you sure you want to delete this unit?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancel', style: TextStyle(color: Colors.black),),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          unitProvider.deleteUnit(unit.id);
                                        },
                                        child: const Text('Delete', style: TextStyle(color: Colors.white),),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
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

