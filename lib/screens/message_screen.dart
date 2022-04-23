import 'package:flutter/material.dart';

import '../src/constants.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  int _tabIndex = 0;

  final List tabIcons = [
    Icons.folder_shared_outlined,
    Icons.notifications,
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox.expand(
        child: Column(
          children: [
            Row(
              children: List.generate(
                tabIcons.length,
                (index) => Flexible(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _tabIndex = index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: _tabIndex == index
                              ? const BorderSide(
                                  width: 2,
                                  color: CustomColors.black,
                                )
                              : const BorderSide(
                                  width: 1,
                                  color: CustomColors.grey,
                                ),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Icon(
                        tabIcons[index],
                        color: _tabIndex == index
                            ? CustomColors.black
                            : CustomColors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: _tabIndex,
                children: [
                  ListView.builder(
                    itemCount: 20,
                    itemBuilder: (ctx, index) {
                      return const ListTile(
                        leading: CircleAvatar(
                          backgroundColor: CustomColors.blue,
                        ),
                        title: Text(
                          'Tran Huy Canh',
                        ),
                        subtitle: Text('Hi bro😉'),
                        trailing: Text('2:00 PM'),
                      );
                    },
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'This Week',
                            style: CustomTextStyle.title3,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: const [
                                CircleAvatar(
                                  backgroundColor: CustomColors.purple,
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                  child: Text(
                                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text('3d'),
                              ],
                            ),
                          ),
                          const Text(
                            'This Month',
                            style: CustomTextStyle.title3,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: const [
                                CircleAvatar(
                                  backgroundColor: Colors.amber,
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                  child: Text(
                                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text('3d'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
