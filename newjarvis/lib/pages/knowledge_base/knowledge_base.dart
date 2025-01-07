import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newjarvis/components/knowledge_base/knowledge_base_createkb.dart';
import 'package:newjarvis/components/widgets/floating_button.dart';
import 'package:newjarvis/components/route/route_controller.dart';
import 'package:newjarvis/components/widgets/side_bar.dart';
import 'package:newjarvis/pages/knowledge_base/knowledge_base_unit.dart';
import 'package:newjarvis/providers/knowledge_base_provider/knowledge_base_provider.dart';
import 'package:newjarvis/providers/knowledge_base_provider/knowledge_base_unit_provider.dart';
import 'package:provider/provider.dart';

class KnowledgePage extends StatefulWidget {
  const KnowledgePage({super.key});

  @override
  State<KnowledgePage> createState() => _KnowledgeState();
}

class _KnowledgeState extends State<KnowledgePage> {
  int selectedIndex = 2;
  bool isExpanded = false;
  bool isSidebarVisible = false;
  bool isDrawerVisible = false;
  double dragOffset = 200.0;

  


  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      isSidebarVisible = false;
    });

    // Navigate to the selected page
    RouteController.navigateTo(index);
  }

  String formatDate(String isoDate) {
  try {
    final DateTime dateTime = DateTime.parse(isoDate);
    return DateFormat('dd-MM-yyyy HH:mm:ss').format(dateTime);
  } catch (e) {
    return isoDate; // Trả về nguyên nếu lỗi
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

  @override
  Widget build(BuildContext context) {
    final knowledgeProvider = Provider.of<KnowledgeBaseProvider>(context);
    final knowledgeList = knowledgeProvider.knowledgeList;
    final filteredKnowledgeList = knowledgeProvider.filteredKnowledgeList;
    final isLoading = knowledgeProvider.isLoading;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        leading: const Icon(
          Icons.book,
        ),
        title: const Text(
          'Knowledge',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Times New Roman',
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [

          if(isLoading)
            const Center(
              child: CircularProgressIndicator(),
            )
          else
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: knowledgeProvider.searchController,
                  decoration: InputDecoration(
                    hintText: 'Search',
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
                // Create Knowledge Button
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CreateKnowledgeDialog(
                            onConfirm: knowledgeProvider.addKnowledge);
                      },
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade900,
                      // Các cài đặt style khác (nếu cần)
                    ),
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Create Knowledge',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 8.0),
                // Knowledge List
                Expanded(
                  child: filteredKnowledgeList.isEmpty
                      ? const Center(
                          child: Text(
                            'No knowledge entries found. Click "Create Knowledge" to add one.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0),
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredKnowledgeList.length,
                          itemBuilder: (context, index) {
                            final knowledge = filteredKnowledgeList[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                  horizontal:
                                      4.0), // Tăng khoảng cách giữa các Card
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
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 12.0),
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(249, 43, 34, 165),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12.0),
                                        topRight: Radius.circular(12.0),
                                      ),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        final unitProvider =
                                            Provider.of<UnitProvider>(context,
                                                listen: false);

                                        // Hiển thị loading dialog
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          },
                                        );

                                        // Thiết lập dữ liệu và tải danh sách trước khi chuyển màn hình
                                        unitProvider.setKnowledgeDetails(
                                          name: knowledge.name,
                                          id: knowledge.id,
                                          description: knowledge.description,
                                          units: knowledge.numUnits,
                                        );

                                        unitProvider
                                            .loadUnitListOfKnowledge()
                                            .then((_) {
                                          // Đóng loading dialog
                                          Navigator.of(context).pop();

                                          // Chuyển sang màn hình mới
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const KnowledgeUnitScreen(),
                                            ),
                                          );
                                        }).catchError((error) {
                                          // Đóng loading dialog nếu có lỗi
                                          Navigator.of(context).pop();

                                          // Hiển thị thông báo lỗi
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Error loading units: $error'),
                                            ),
                                          );
                                        });
                                      },
                                      child: Text(
                                        knowledge.name,
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),

                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 12.0),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12.0),
                                        bottomRight: Radius.circular(12.0),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Units
                                        Row(
                                          children: [
                                            const Text(
                                              "Units: ",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                "${knowledge.numUnits}",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.normal,
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
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                formatSize(knowledge.totalSize),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5.0),

                                        // Edit Time
                                        Row(
                                          children: [
                                            const Text(
                                              "Edit Time: ",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                formatDate(knowledge.updatedAt),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5.0),

                                        // Description
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Description: ",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                knowledge.description,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Nút delete nằm dưới cùng
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.black54),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  'Delete Confirmation'),
                                              content: const Text(
                                                  'Are you sure you want to delete this knowledge entry?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                  ),
                                                  onPressed: () async {
                                                    Navigator.of(context).pop();
                                                    knowledgeProvider
                                                        .deleteKnowledge(
                                                            knowledgeList[index]
                                                                .id);
                                                  },
                                                  child: const Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
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
          
          // SideBar
          if (isSidebarVisible)
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: SideBar(
                isExpanded: isExpanded,
                selectedIndex: selectedIndex,
                onItemSelected: _onItemTapped,
                onExpandToggle: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                onClose: () {
                  setState(() {
                    isSidebarVisible = false;
                  });
                },
              ),
            ),

          // Nửa hình tròn khi sidebar bị ẩn (Floating Button)
          if (!isSidebarVisible)
            FloatingButton(
              dragOffset: dragOffset,
              onDragUpdate: (delta) {
                setState(
                  () {
                    dragOffset += delta;
                    if (dragOffset < 0) dragOffset = 0;
                    if (dragOffset > MediaQuery.of(context).size.height - 100) {
                      dragOffset = MediaQuery.of(context).size.height - 100;
                    }
                  },
                );
              },
              onTap: () {
                setState(
                  () {
                    isSidebarVisible = true;
                  },
                );
              },
            ),
  ],
  
      ),
    );
  }
}
