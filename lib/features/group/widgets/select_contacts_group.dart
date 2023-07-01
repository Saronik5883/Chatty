import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Chatty_ui/common/widgets/error.dart';
import 'package:Chatty_ui/common/widgets/loader.dart';
import 'package:Chatty_ui/features/select_contacts/controller/select_contact_controller.dart';

final selectedGroupContacts = StateProvider<List<Contact>>((ref) => []);

class SelectContactsGroup extends ConsumerStatefulWidget {
  const SelectContactsGroup({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _SelectContactsGroupState();
}

class _SelectContactsGroupState extends ConsumerState<SelectContactsGroup> {
  List<int> selectedContactsIndex = [];

  void selectContact(int index, Contact contact){
    if(selectedContactsIndex.contains(index)) {
      selectedContactsIndex.removeAt(index);
    }else{
      selectedContactsIndex.add(index);
    }
    setState(() {});
    ref.read(selectedGroupContacts.state)
        .update((state) => [...state,contact]);
  }


  @override
  Widget build(BuildContext context) {
    return  ref.watch(getContactProvider).when(
        data: (contactList) => Expanded(
            child: ListView.builder(
                itemCount: contactList.length,
                itemBuilder: (context, index){
              final contact = contactList[index];
              return InkWell(
                onTap: () => selectContact(index, contact),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                  child: ListTile(
                    leading: selectedContactsIndex.contains(index) ?
                    const Icon(Icons.check_circle, color: Colors.green, size: 40,) :
                         const Icon(Icons.account_circle, color: Colors.grey, size: 40,),
                    title: Text(contact.displayName, style: const TextStyle(fontSize: 18),),
                  ),
                ),
              );
            })
        ),
        error: (err, trace) => ErrorScreen(error: err.toString()),
        loading: () => const Loader()
    );
  }
}
