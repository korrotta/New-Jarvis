import 'package:flutter/material.dart';

class ScreenArt extends StatefulWidget {
  const ScreenArt({super.key});

  @override
  State<ScreenArt> createState() {
    return buildScreenArt();
  }
}

class buildScreenArt extends State<ScreenArt> {
  @override
  Widget build(Object context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 242, 242),
      appBar: _buildAppBar(),
      body: _buildBody(),
    ));
  }

  AppBar _buildAppBar() {
    return
        // Empty AppBar
        AppBar(
      backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
      title: const Text(
        "Art",
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontFamily: "Times New Roman"),
        textAlign: TextAlign.left,
        // ignore: deprecated_member_use
        textScaleFactor: 1.3,
      ),
      elevation: 0,
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
        child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Wrap(
                      children: [
                        const Text(
                            "🎉 Your personal artist is now online and ready to bring your vision to life!"),
                        const Text(
                            "💬 Just tell me what you're imagining - 🏖️ a beach at sunset, 🏙️ a nighttime cityscape, 🐕 a cute pup running through a field - and I'll conjure up a stunning, one-of-a-kind masterpiece that perfectly captures your idea."),
                        const Text(
                            "e.g: a ballerina dances in the harbor at dusk."),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image.asset(
                            "assets/icons/picture_1.png",
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const Text(
                            "Let's embark on a journey of creativity together and create some truly amazing works of art 🎨!")
                      ],
                    )),
                const SizedBox(height: 16.0),
                const SizedBox(height: 50.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(children: [
                      Container(
                          height: 30,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(235, 240, 233, 233),
                            borderRadius: BorderRadius.circular(35.0),
                          ),
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(width: 7.0),
                              Icon(
                                Icons.account_circle,
                                size: 20.0,
                              ),
                              const SizedBox(width: 3.0),
                              Text(
                                "Artist",
                                style: TextStyle(fontWeight: FontWeight.w700),
                                textScaleFactor: 1.0,
                              ),
                              Transform.translate(
                                  offset: const Offset(0, -3.0),
                                  child: IconButton(
                                    icon: const Icon(Icons.arrow_drop_down),
                                    iconSize: 22,
                                    onPressed: () {},
                                  ))
                            ],
                          )))
                    ]),
                    const Spacer(),
                    const Spacer(),
                    const Spacer(),
                    const Spacer(),
                    Flexible(
                      child: IconButton(
                        icon: const Icon(Icons.add_photo_alternate),
                        onPressed: () {
                          // Xử lý khi add photo
                        },
                      ),
                    ),
                    Flexible(
                      child: IconButton(
                        icon: const Icon(Icons.tune),
                        onPressed: () {
                          // Xử lý khi chọn muilti format prompt
                        },
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(235, 240, 233, 233),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Column(
                    children: [
                      const TextField(
                        decoration: InputDecoration(
                          hintText:
                              'Describe your creation in English. Non-English descriptions will be translated automatically.',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                            fontFamily: 'Arial',
                          ),
                          border: InputBorder.none,
                        ),
                        maxLines: null,
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text("e.g. "),
                          Flexible(
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(183, 225, 224, 224),
                                borderRadius: BorderRadius.circular(35.0),
                              ),
                              child: const Text("🐶 a cute dog"),
                            ),
                          ),
                          Flexible(
                              child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(183, 225, 224, 224),
                              borderRadius: BorderRadius.circular(35.0),
                            ),
                            child: const Text("🏞️ a cabin by the"),
                          ))
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                        width: 104,
                        height: 29,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(235, 209, 155, 234),
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                        child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.flash_on_outlined,
                                  color: Color.fromARGB(255, 81, 0, 181),
                                  size: 18),
                              Text(
                                "Images: ",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 81, 0, 181),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                "0",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 81, 0, 181),
                                ),
                              )
                            ])))
              ],
            )));
  }
}
