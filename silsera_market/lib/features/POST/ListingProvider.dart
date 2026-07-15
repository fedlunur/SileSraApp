import 'package:flutter/material.dart';
import 'package:silesra/core/config/MiscillaniousModels.dart';
import 'package:silesra/features/Accessory/data/accessory_model.dart';
import 'package:silesra/features/Auth/models/user_model.dart';
import 'package:silesra/features/Cars/data/models/car_model.dart';
import 'package:silesra/features/Electronics/data/model/electronics_model.dart';
import 'package:silesra/features/Fashion/data/model/fashion_model.dart';
import 'package:silesra/features/FreeStuff/data/model/free_stuff_model.dart';
import 'package:silesra/features/House/data/model/house_model.dart';
import 'package:silesra/features/Job/data/model/job_vacancy.dart';
import 'package:silesra/features/LOF/data/model/lof_model.dart';
import 'package:silesra/features/OtherItems/data/model/otheritem_model.dart';
import 'package:silesra/features/POST/BaseService.dart';
import 'package:silesra/features/POST/ImageModel.dart';
import 'package:silesra/features/Posted_Items/posted_itemmodel.dart';
import 'package:silesra/features/Service/data/model/service_model.dart';
import 'package:silesra/features/Watchlist/data/model/watch_list_model.dart';

class ListingProvider with ChangeNotifier {
  final BaseService<ElectronicsModel> electronicsService =
      BaseService<ElectronicsModel>('electronics');
  final BaseService<AccessoryModel> accessoryService =
      BaseService<AccessoryModel>('accessory');
  // DO the same for Fashion
  final BaseService<FashionModel> fashionService =
      BaseService<FashionModel>('fashion');
  final BaseService<CarModel> carService = BaseService<CarModel>('car');
  final BaseService<HouseModel> houseService = BaseService<HouseModel>('house');
  final BaseService<LostOrFound> lofService = BaseService<LostOrFound>('lof');
  final BaseService<Watchlist> watchlistService =
      BaseService<Watchlist>('watchlist');
  final BaseService<JobVacancyModel> jobService =
      BaseService<JobVacancyModel>('jobvacancy');
  final imageService = BaseService<ImageUpmodel>('image');
  final BaseService<User> userService = BaseService<User>('user');
  final BaseService<PostedItem> postedItemService =
      BaseService<PostedItem>('savedproducts');
  final BaseService<NotificationResponse> notificationService =
      BaseService<NotificationResponse>('notification');
  final BaseService<ServiceOrBusinessType> serviceService =
      BaseService<ServiceOrBusinessType>('service');
  final BaseService<FreeStaffOrItem> freeItemService =
      BaseService<FreeStaffOrItem>('freeitem');
  final BaseService<OtherItem> othersService =
      BaseService<OtherItem>('otheritem');

  final BaseService<ChatRoom> chatroomService =
      BaseService<ChatRoom>('chatroom');
}
