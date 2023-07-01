import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Chatty_ui/common/widgets/loader.dart';
import 'package:Chatty_ui/features/status/controller/status_controller.dart';
import 'package:Chatty_ui/features/status/screens/status_screen.dart';
import 'package:Chatty_ui/models/status_model.dart';

import '../../../colors.dart';
import '../../../info.dart';

class StatusContactsScreen extends ConsumerWidget {
  const StatusContactsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    bool isViewed = false;

    return FutureBuilder<List<Status>>(
      future: ref.read(statusControllerProvider).getStatus(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            var statusData = snapshot.data![index];
            return Column(
              children: [
                const SizedBox(height: 20,),
                InkWell(
                  onTap: () {
                    isViewed = true;
                    Navigator.pushNamed(
                      context,
                      StatusScreen.routeName,
                      arguments: statusData,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      title: Text(
                        statusData.username,
                      ),
                      leading: Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          color: const Color(0xff7c94b6),
                          image: DecorationImage(
                            image: NetworkImage(
                                statusData.profilePic,
                            ),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all( Radius.circular(50.0)),
                          border: Border.all(
                            color: isViewed ? Theme.of(context).colorScheme.primary : Colors.grey,
                            width: 4.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const Divider(color: dividerColor, indent: 85),

                InkWell(
                  onTap: () {
                    isViewed = true;
                    Navigator.pushNamed(
                      context,
                      StatusScreen.routeName,
                      arguments: statusData,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      title: Text(
                        info[0]['name'].toString(),
                      ),
                      leading: Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          color: const Color(0xff7c94b6),
                          image: DecorationImage(
                            image: NetworkImage(
                             info[0]['profilePic'].toString(),
                            ),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all( Radius.circular(50.0)),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 4.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}