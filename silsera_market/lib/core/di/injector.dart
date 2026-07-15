import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:silesra/features/Accessory/data/accessory_data.dart';
import 'package:silesra/features/Accessory/domain/accessory_domain.dart';
import 'package:silesra/features/Accessory/presentation/bloc/accessory_bloc.dart';
import 'package:silesra/features/Cars/data/remote/remote_data_car_impl.dart';
import 'package:silesra/features/Cars/data/repository/car_repository_impl.dart';
import 'package:silesra/features/Cars/domain/repositories/car_repository.dart';
import 'package:silesra/features/Cars/domain/usecases/car_usecase.dart';
import 'package:silesra/features/Cars/presentation/bloc/car_bloc.dart';
import 'package:silesra/features/Electronics/bloc/electronics_bloc.dart';
import 'package:silesra/features/Electronics/data/datasource/remote_data_source.dart';
import 'package:silesra/features/Electronics/domain/repo/electronics_domain.dart';
import 'package:silesra/features/Electronics/domain/usecases/usecases.dart';
import 'package:silesra/features/Fashion/data/remote/remote_data_source.dart';
import 'package:silesra/features/Fashion/domain/fashion_domain.dart';
import 'package:silesra/features/Fashion/domain/usecases.dart';
import 'package:silesra/features/Fashion/presenation/bloc/fashion_bloc.dart';
import 'package:silesra/features/FreeStuff/bloc/freestaff_bloc.dart';
import 'package:silesra/features/FreeStuff/data/datasource/fs_data.dart';
import 'package:silesra/features/FreeStuff/domain/free_stuff_domain.dart';
import 'package:silesra/features/House/data/datasources/remote/remote_datasource_house.dart';
import 'package:silesra/features/House/data/repo/house_rpo_impl.dart';
import 'package:silesra/features/House/domain/repo/house_repo.dart';
import 'package:silesra/features/House/domain/usecase/get_house_by_id.dart';
import 'package:silesra/features/House/domain/usecase/house_getusecase.dart';
import 'package:silesra/features/House/domain/usecase/the_rest_house_usecase.dart';
import 'package:silesra/features/House/presentation/bloc/house_bloc_bloc.dart';
import 'package:silesra/features/Job/data/remote_data/remote_data_job.dart';
import 'package:silesra/features/Job/domain/job_usecase.dart';
import 'package:silesra/features/Job/domain/repo.dart';
import 'package:silesra/features/Job/presentation/bloc/job_bloc.dart';
import 'package:silesra/features/LOF/data/data/lof_data.dart';
import 'package:silesra/features/LOF/domain/lof_domain.dart';
import 'package:silesra/features/LOF/presentation/lof_bloc.dart';
import 'package:silesra/features/News/Block/block.dart';
import 'package:silesra/features/News/Repository/repository.dart';
import 'package:silesra/features/Notification/bloc/notification_bloc.dart';
import 'package:silesra/features/Notification/datasource/notification_remote_datasource.dart';
import 'package:silesra/features/Notification/datasource/notification_repository_impl.dart';
import 'package:silesra/features/Notification/domain/usecases/notification_usecases.dart';
import 'package:silesra/features/OtherItems/bloc/other_item_bloc.dart';
import 'package:silesra/features/OtherItems/data/datasource/remotedatasource.dart';
import 'package:silesra/features/OtherItems/data/model/repo/repo.dart';
import 'package:silesra/features/OtherItems/data/usecase/usecase.dart';
import 'package:silesra/features/POST/BaseService.dart';
import 'package:silesra/features/Service/data/datasource/service_data_layer.dart';
import 'package:silesra/features/Service/domain/service_domain_layer.dart';
import 'package:silesra/features/Service/presentation/service_bloc.dart';
import 'package:silesra/features/Watchlist/bloc/watchlist_bloc.dart';
import 'package:silesra/features/Watchlist/data/model/watchlist_repo.dart';
import 'package:silesra/features/Watchlist/data/watchlist_datasource/watchlist_datasource.dart';
import 'package:silesra/features/Watchlist/domain/watchList_usecase.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Dio instance for network requests
  final dio = Dio();

  // Notification Dependencies
  getIt.registerLazySingleton(
    () => GetNotifications(getIt<NotificationRepository>()),
  );
  getIt.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(
      remoteDataSource: getIt<NotificationRemoteDatasource>(),
    ),
  );
  getIt.registerLazySingleton<NotificationRemoteDatasource>(
    () => NotificationRemoteDataSourceImpl(dio: dio),
  );
  getIt.registerFactory(
    () => NotificationBloc(
      getNotificationsUseCase: getIt<GetNotifications>(),
    ),
  );

  // FreeStaff Dependencies
  getIt.registerLazySingleton(
    () => GetFreeStaffOrItems(getIt<FreeStaffOrItemRepository>()),
  );
  getIt.registerLazySingleton<FreeStaffOrItemRepository>(
    () => FreeStaffOrItemRepositoryImpl(
      remoteDataSource: getIt<FreeStaffOrItemRemoteDataSource>(),
    ),
  );
  getIt.registerLazySingleton<FreeStaffOrItemRemoteDataSource>(
    () => FreeStaffOrItemRemoteDataSourceImpl(
        baseService: BaseService('freestafforitem'), dio: dio),
  );

  // ServicesorBusinessType Dependencies
  getIt.registerLazySingleton<ServiceOrBusinessTypeRemoteDataSource>(
    () => ServiceOrBusinessTypeRemoteDataSourceImpl(
        baseService: BaseService('bussinessorservicetypes'), dio: dio),
  );
  getIt.registerLazySingleton<ServiceOrBusinessTypeRepository>(
    () => ServiceOrBusinessTypeRepositoryImpl(
      remoteDataSource: getIt<ServiceOrBusinessTypeRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton(
    () => GetServiceOrBusinessTypes(getIt<ServiceOrBusinessTypeRepository>()),
  );
  getIt.registerLazySingleton(
    () =>
        GetServiceOrBusinessTypeById(getIt<ServiceOrBusinessTypeRepository>()),
  );
  getIt.registerLazySingleton(
    () => AddServiceOrBusinessType(getIt<ServiceOrBusinessTypeRepository>()),
  );
  getIt.registerLazySingleton(
    () => UpdateServiceOrBusinessType(getIt<ServiceOrBusinessTypeRepository>()),
  );
  getIt.registerLazySingleton(
    () => DeleteServiceOrBusinessType(getIt<ServiceOrBusinessTypeRepository>()),
  );
  getIt.registerFactory(
    () => ServiceOrBusinessTypeBloc(
      getServiceOrBusinessTypes: getIt<GetServiceOrBusinessTypes>(),
    ),
  );

  // Electronics Dependencies
  getIt.registerLazySingleton<ElectronicsRemoteDataSource>(
    () => ElectronicsRemoteDataSourceImpl(
        baseService: BaseService('electronics'), dio: dio),
  );
  getIt.registerLazySingleton<ElectronicsRepository>(
    () => ElectronicsRepositoryImpl(
      remoteDataSource: getIt<ElectronicsRemoteDataSource>(),
    ),
  );
  getIt.registerLazySingleton(
    () => GetElectronicsUseCase(repository: getIt<ElectronicsRepository>()),
  );

  getIt.registerFactory(
    () => ElectronicsBloc(
      getElectronicsUseCase: getIt<GetElectronicsUseCase>(),
    ),
  );
  getIt.registerFactory(
    () => FreestaffBloc(
      getFreeStaffOrItems: getIt<GetFreeStaffOrItems>(),
    ),
  );

  // Fashion Dependencies
  getIt.registerLazySingleton<FashionRemoteDataSource>(
    () => FashionRemoteDataSourceImpl(
        baseService: BaseService('fashion'), dio: dio),
  );
  getIt.registerLazySingleton<FashionRepository>(
    () => FashionRepositoryImpl(
      remoteDataSource: getIt<FashionRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton(
      () => GetFashionsUseCase(repository: getIt<FashionRepository>()));
  getIt.registerFactory<FashionBloc>(
    () => FashionBloc(getFashionsUseCase: getIt<GetFashionsUseCase>()),
  );
  // Accessory Dependencies

  getIt.registerLazySingleton<AccessoryRemoteDataSourceImpl>(
      () => AccessoryRemoteDataSourceImpl(
            dio: dio,
            baseService: BaseService('accessory'),
          ));
  getIt.registerLazySingleton(
      () => GetAccessoryUseCase(getIt<AccessoryRemoteDataSourceImpl>()));
  // Register AccessoryRemoteDataSource as a lazy singleton
  getIt.registerLazySingleton<AccessoryRemoteDataSource>(
    () => AccessoryRemoteDataSourceImpl(
      baseService: BaseService('accessory'),
      dio: dio,
    ),
  );

  // Register GetAccessoryUseCase as a lazy singleton

  // Register AccessoryBloc as a factory
  getIt.registerFactory<AccessoryBloc>(
    () => AccessoryBloc(getAccessoryUseCase: getIt<GetAccessoryUseCase>()),
  );

  // Watchlist dependencies
  getIt.registerLazySingleton<WatchlistRemoteDataSource>(
    () => WatchlistRemoteDataSourceImpl(
        baseService: BaseService('watchlist'), dio: dio),
  );

  getIt.registerLazySingleton<WatchlistRepository>(
    () => WatchlistRepositoryImpl(
        remoteDataSource: getIt<WatchlistRemoteDataSource>()),
  );

  getIt
      .registerLazySingleton(() => GetWatchlists(getIt<WatchlistRepository>()));

  getIt.registerFactory(
    () => WatchlistBloc(getWatchlists: getIt<GetWatchlists>(), dio: dio),
  );

  // Car dependencies
  getIt.registerLazySingleton<CarRemoteDataSource>(
    () => CarRemoteDataSourceImpl(baseService: BaseService('car'), dio: dio),
  );

  getIt.registerLazySingleton<CarRepository>(
    () => CarRepositoryImpl(remoteDataSource: getIt<CarRemoteDataSource>()),
  );

  getIt.registerLazySingleton(() => GetCars(getIt<CarRepository>()));
  getIt.registerLazySingleton(() => GetCarById(getIt<CarRepository>()));
  getIt.registerLazySingleton(() => AddCar(getIt<CarRepository>()));
  getIt.registerLazySingleton(() => UpdateCar(getIt<CarRepository>()));
  getIt.registerLazySingleton(() => DeleteCar(getIt<CarRepository>()));

  getIt.registerFactory(
    () => CarBloc(
      getCars: getIt<GetCars>(),
      getCarById: getIt<GetCarById>(),
      addCar: getIt<AddCar>(),
      updateCar: getIt<UpdateCar>(),
      deleteCar: getIt<DeleteCar>(),
    ),
  );

  // House dependencies
  getIt.registerLazySingleton<HouseRemoteDataSource>(
    () =>
        HouseRemoteDataSourceImpl(baseService: BaseService('house'), dio: dio),
  );

  getIt.registerLazySingleton<HouseRepository>(
    () => HouseRepositoryImpl(remoteDataSource: getIt<HouseRemoteDataSource>()),
  );

  getIt.registerLazySingleton(() => GetHouses(getIt<HouseRepository>()));
  getIt.registerLazySingleton(() => GetHouseById(getIt<HouseRepository>()));
  getIt.registerLazySingleton(() => AddHouse(getIt<HouseRepository>()));
  getIt.registerLazySingleton(() => UpdateHouse(getIt<HouseRepository>()));
  getIt.registerLazySingleton(() => DeleteHouse(getIt<HouseRepository>()));

  getIt.registerFactory(
    () => HouseBloc(
      getHouses: getIt<GetHouses>(),
      getHouseById: getIt<GetHouseById>(),
      addHouse: getIt<AddHouse>(),
      updateHouse: getIt<UpdateHouse>(),
      deleteHouse: getIt<DeleteHouse>(),
    ),
  );

  // JobVacancy dependencies
  getIt.registerLazySingleton<JobVacancyRemoteDataSource>(
    () => JobVacancyRemoteDataSourceImpl(
        baseService: BaseService('jobvacancy'), dio: dio),
  );

  getIt.registerLazySingleton<JobVacancyRepository>(
    () => JobVacancyRepositoryImpl(
        remoteDataSource: getIt<JobVacancyRemoteDataSource>()),
  );

  getIt.registerLazySingleton(
      () => GetJobVacancies(getIt<JobVacancyRepository>()));
  getIt.registerLazySingleton(
      () => GetJobVacancyById(getIt<JobVacancyRepository>()));
  getIt.registerLazySingleton(
      () => AddJobVacancy(getIt<JobVacancyRepository>()));
  getIt.registerLazySingleton(
      () => UpdateJobVacancy(getIt<JobVacancyRepository>()));
  getIt.registerLazySingleton(
      () => DeleteJobVacancy(getIt<JobVacancyRepository>()));

  getIt.registerFactory(
    () => JobVacancyBloc(
      getJobVacancies: getIt<GetJobVacancies>(),
      addJobVacancy: getIt<AddJobVacancy>(),
      updateJobVacancy: getIt<UpdateJobVacancy>(),
      deleteJobVacancy: getIt<DeleteJobVacancy>(),
      getJobVacancyById: getIt<GetJobVacancyById>(),
    ),
  );

  // LostOrFound dependencies
  getIt.registerLazySingleton<LostOrFoundRemoteDataSource>(
    () => LostOrFoundRemoteDataSourceImpl(
        baseService: BaseService('lostorfoud'), dio: dio),
  );

  getIt.registerLazySingleton<LostOrFoundRepository>(
    () => LostOrFoundRepositoryImpl(
        remoteDataSource: getIt<LostOrFoundRemoteDataSource>()),
  );

  getIt.registerLazySingleton(
      () => GetLostOrFounds(getIt<LostOrFoundRepository>()));
  getIt.registerLazySingleton(
      () => GetLostOrFoundById(getIt<LostOrFoundRepository>()));
  getIt.registerLazySingleton(
      () => AddLostOrFound(getIt<LostOrFoundRepository>()));
  getIt.registerLazySingleton(
      () => UpdateLostOrFound(getIt<LostOrFoundRepository>()));
  getIt.registerLazySingleton(
      () => DeleteLostOrFound(getIt<LostOrFoundRepository>()));

  getIt.registerFactory(
    () => LostOrFoundBloc(
      getLostOrFounds: getIt<GetLostOrFounds>(),
      getLostOrFoundById: getIt<GetLostOrFoundById>(),
      addLostOrFound: getIt<AddLostOrFound>(),
      updateLostOrFound: getIt<UpdateLostOrFound>(),
      deleteLostOrFound: getIt<DeleteLostOrFound>(),
    ),
  );

  // Register Remote Data Source
  getIt.registerSingleton<OtherItemRemoteDataSource>(
    OtherItemRemoteDataSourceImpl(
        baseService: BaseService('otheritemcatagory'), dio: dio),
  );

  // Register Repository
  getIt.registerSingleton<OtherItemRepository>(
    OtherItemRepositoryImpl(
        remoteDataSource: getIt<OtherItemRemoteDataSource>()),
  );

  // Register Use Cases
  getIt.registerSingleton<GetOtherItems>(
      GetOtherItems(getIt<OtherItemRepository>()));
  getIt.registerSingleton<GetOtherItemById>(
      GetOtherItemById(getIt<OtherItemRepository>()));
  getIt.registerSingleton<AddOtherItem>(
      AddOtherItem(getIt<OtherItemRepository>()));
  getIt.registerSingleton<UpdateOtherItem>(
      UpdateOtherItem(getIt<OtherItemRepository>()));
  getIt.registerSingleton<DeleteOtherItem>(
      DeleteOtherItem(getIt<OtherItemRepository>()));

  // Register Bloc
  getIt.registerFactory(
    () => OtherItemBloc(
      getOtherItems: getIt<GetOtherItems>(),
      addOtherItem: getIt<AddOtherItem>(),
      updateOtherItem: getIt<UpdateOtherItem>(),
      deleteOtherItem: getIt<DeleteOtherItem>(),
    ),
  );
  getIt.registerLazySingleton<ApiRepository>(() => ApiRepository());
  getIt.registerFactory<PromotionsPlansNewsBloc>(
      () => PromotionsPlansNewsBloc(getIt<ApiRepository>()));
}
