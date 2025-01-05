import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newjarvis/components/route/route_controller.dart';
import 'package:newjarvis/components/widgets/floating_button.dart';
import 'package:newjarvis/components/widgets/side_bar.dart';

class ScreenSetUpEmail extends StatefulWidget{
  const ScreenSetUpEmail({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ScreenSetUpEmail();
  }
}

class _ScreenSetUpEmail extends State<ScreenSetUpEmail>{

  int selectedIndex = 0; 
  int selectedSmallIndexLength = -1; 
  final List<String> listLength = ["Auto", "Short", "Medium", "Long"];
  
  int selectedSmallIndexFormat = -1;
  final List<String> listFormat = ["Auto", "Email", "Message", "Comment", "Paragraph", "Article", "Blog post", "Ideas", "Outline", "Twitter"];
  
  int selectedSmallIndexTone = -1;
  final List<String> listTone = ["Auto", "Amicable", "Casual", "Friendly", "Professional", "Witty", "Funny", "Formal"];


  bool _isGpt4Enabled = false;

  int selectedIndexSideBar = 3;
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

  @override
  Widget build(BuildContext context) {
    
    return SafeArea(
      child: Scaffold(
            appBar: _buildAppBar(),
            body:  
            Stack(children: [
              _buildBody(),
              // SideBar
              if (isSidebarVisible)
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: 0,
                  child: SideBar(
                    isExpanded: isExpanded,
                    selectedIndex: selectedIndexSideBar,
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
            ],),

          backgroundColor: const Color.fromARGB(255, 245, 242, 242),
        )
      );
  }

  AppBar _buildAppBar(){
    return 
      AppBar(
        backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
        title: 
        Row(
        children: [
          
          const Text(
            "Email",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: "Times New Roman",
              fontSize: 23,
            ),
            textAlign: TextAlign.left,
          ),
    

          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min, 
                  children: [
                    Image.asset(
                      "assets/icons/book.png",
                      width: 21,
                      height: 22,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 5),
                    
                    const Text(
                      "Email Agent",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Arial",
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: false,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
        ),
        elevation: 0,
      );
  }



  Widget _buildBody() {

    return SingleChildScrollView(
      child: Container(
      height: MediaQuery.of(context).size.height, // Đảm bảo chiều cao luôn chiếm toàn bộ màn hình
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        
        child: Column(

          mainAxisAlignment: MainAxisAlignment.start,
          

          children:[
            Align(
            alignment: Alignment.centerLeft,
            child: FittedBox(
              fit: BoxFit.contain,
              child: 
              Row(
              children: [ 
                Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(1000.0),
                ),
                
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: [
                    _buildTextOption("Compose", 0),
                    _buildTextOption("Reply", 1),
                    _buildTextOption("Grammar", 2),
                  ],
                ),
              ),
              
              const SizedBox(width: 110),

              Container(
              width: 35,
              height: 35,
              padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 7.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 245, 242, 242),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: Colors.black, // Màu viền
                  width: 0.5, // Độ dày của viền
                ),
              ),

              child: Image.asset("assets/icons/menu_write.png"),
              )
              ]
            ),
            ),
            ),

            const SizedBox(height: 21.0),

            const Row(children: [Text("Write About", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black),)],),
            
            const SizedBox(height: 5.0),

            Container(
            height: 130,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
            color: const Color.fromARGB(117, 231, 227, 227), 
            borderRadius: BorderRadius.circular(16.0),
            ),

            child: const Column(children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Tell me what to write email for you. Hit Ctrl + Enter to generate.',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontFamily: 'Arial',
                    ),
              
                border: InputBorder.none, 
                ),
              maxLines: null,
              ),
            ]
            ),
            ),

            const SizedBox(height: 21.0),

            const Row(children: [Text("Length", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black),)],),
            
            const SizedBox(height: 5.0),


            // Length
            Align(

            alignment: Alignment.centerLeft,
            child: LayoutBuilder(builder: (context, constraints){
            return Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: List.generate(4, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedSmallIndexLength = (index >= 0 && index < listLength.length) ? index : -1;
                        });
                      },
                      
                      child: IntrinsicWidth(
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: selectedSmallIndexLength == index ? const Color.fromARGB(255, 202, 172, 241) : Colors.grey[300],
                          borderRadius: BorderRadius.circular(8.0),
                        ),

                        child: Text(
                          listLength[index],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            fontFamily: "Arial",
                            color: selectedSmallIndexLength == index ? const Color.fromARGB(255, 0, 0, 0) : Colors.black,
                          ),
                        ),
                      )
                    )
                    );
                  }),
                );
            }
            )
            ),

            const SizedBox(height: 21.0),

            const Row(children: [Text("Format", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black),)],),
            
            const SizedBox(height: 5.0),


            // Format 
            Align(

            alignment: Alignment.centerLeft,

            child: LayoutBuilder(
              builder: (context, constraints) {
                return Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: List.generate(10, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedSmallIndexFormat = (index >= 0 && index < listFormat.length) ? index : -1;
                        });
                      },

                      child: IntrinsicWidth(
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            color: selectedSmallIndexFormat == index
                                ? const Color.fromARGB(255, 202, 172, 241)
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8.0),
                          ),

                          child: Text(
                            listFormat[index],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              fontFamily: "Arial",
                              color: selectedSmallIndexFormat == index
                                  ? const Color.fromARGB(255, 0, 0, 0)
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
            ),



            const SizedBox(height: 21.0),

            const Row(children: [Text("Tone", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black),)],),
            
            const SizedBox(height: 5.0),


            // Tone
            Align(

            alignment: Alignment.centerLeft,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: List.generate(8, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedSmallIndexTone = (index >= 0 && index < listTone.length) ? index : -1;
                        });
                      },

                      child: IntrinsicWidth(
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            color: selectedSmallIndexTone == index
                                ? const Color.fromARGB(255, 202, 172, 241)
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8.0),
                          ),

                          child: Text(
                            listTone[index],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              fontFamily: "Arial",
                              color: selectedSmallIndexTone == index
                                  ? const Color.fromARGB(255, 0, 0, 0)
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),


          const SizedBox(height: 21.0),

          const Row(children: [Text("Output Language", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black),)],),
            
          const SizedBox(height: 5.0),
        
          Row(
          children: [
            Container(
              height: 30,
              decoration: BoxDecoration(
                color: const Color.fromARGB(235, 240, 233, 233),
                borderRadius: BorderRadius.circular(35.0),
              ),

              child: FittedBox( // Sử dụng FittedBox để nội dung bên trong điều chỉnh kích thước
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 16.0),
                    const Text(
                      "Auto",
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textScaleFactor: 1.3,
                    ),

                    const SizedBox(width: 100),

                    Transform.translate(
                      offset: const Offset(0, -3.0),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 22,
                        onPressed: () {},
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
          ),

          const SizedBox(height: 21.0),

          Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 76, 7, 180),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.auto_awesome_outlined,
                      size: 12,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),


                  const SizedBox(width: 5,),
                  
                  const Text("GPT-4", style: TextStyle(fontWeight: FontWeight.bold),),
                  
                  Transform.scale(
                  scale: 0.6,
                  child: CupertinoSwitch(
                    value: _isGpt4Enabled,
                    activeColor: Colors.green,
                    onChanged: (bool value) {
                      setState(() {
                        _isGpt4Enabled = value;
                      });
                    },
                  ),
                  ),
                  
                  const SizedBox(width: 5),

                  Flexible(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    
                    child: Container(
                      width: 220,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 76, 7, 180),
                        borderRadius: BorderRadius.circular(100),
                      ),

                      child: const Center(
                        child: Text(
                          "Regenerate Ctrl ⏎",
                          style: TextStyle(
                            fontFamily: "Arial",
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ),

                ]
          ),
          ],
        ),
      ),
      
    );
  }

  Widget _buildTextOption(String text, int index) {
  return GestureDetector(
    onTap: () {
      setState(() {
        selectedIndex = index;
      });
    },

    child: Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 9.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: selectedIndex == index ? Colors.black : Colors.transparent,
        borderRadius: BorderRadius.circular(1000.0),
      ),

      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: selectedIndex == index ? Colors.white : Colors.black,
        ),
      ),
    ),
  );
}

}