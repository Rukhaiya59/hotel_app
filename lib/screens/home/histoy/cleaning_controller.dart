import 'package:get/get.dart';
import 'package:hotel/model/entity_cleaning_task.dart';
import 'package:hotel/model/entity_user.dart';
import 'package:hotel/model/entity_room.dart';
import 'package:hotel/objectbox.g.dart';
import 'package:hotel/service/service_object_box.dart';

class HousekeepingHistoryController extends GetxController {
  late Box<EntityCleaningTask> boxTask;
  late Box<EntityUser> boxUser;
  late Box<EntityRoom> boxRoom;

  final rxHistory = <EntityCleaningTask>[].obs;

  @override
  void onInit() {
    super.onInit();
    final ob = Get.find<ServiceObjectBox>();

    boxTask = ob.box<EntityCleaningTask>();
    boxUser = ob.box<EntityUser>();
    boxRoom = ob.box<EntityRoom>();

    loadHistory();
  }

  void loadHistory() {
    final qb = boxTask
        .query(EntityCleaningTask_.status.equals("done"))
      ..order(EntityCleaningTask_.completedAt, flags: Order.descending);

    final query = qb.build();      // Build query
    final list = query.find();     // Find items
    query.close();                 // CLOSE THE QUERY (not qb)

    rxHistory.assignAll(list);

  }
}
