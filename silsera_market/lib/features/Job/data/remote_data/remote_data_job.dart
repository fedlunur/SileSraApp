import 'package:dio/dio.dart';
import 'package:silesra/features/Job/data/model/job_vacancy.dart';
import 'package:silesra/features/POST/BaseService.dart';
import 'package:silesra/features/POST/download_image.dart';
import 'package:silesra/core/config/settings.dart';

abstract class JobVacancyRemoteDataSource {
  Future<List<JobVacancyModel>> getJobVacancies();
  Future<JobVacancyModel> getJobVacancyById(String id);
  Future<void> addJobVacancy(JobVacancyModel jobVacancy);
  Future<void> updateJobVacancy(JobVacancyModel jobVacancy);
  Future<void> deleteJobVacancy(String id);
}

class JobVacancyRemoteDataSourceImpl implements JobVacancyRemoteDataSource {
  final Dio dio;
    BaseService<JobVacancyModel> baseService;
  JobVacancyRemoteDataSourceImpl({required this.dio,required this.baseService});

  @override
  Future<List<JobVacancyModel>> getJobVacancies(
      {int page = 1, int pageSize = 10}) async {

    final response = await baseService.getRequestModelData(
      'jobvacancy', // No query parameters here
      page: page,
      pageSize: pageSize,
    );
    final res = (response.data['data'] as List)
        .map((e) => JobVacancyModel.fromJson(e))
        .toList();

    await updateImages('jobs', res);
    return res;
  }

  @override
  Future<JobVacancyModel> getJobVacancyById(String id) async {
    final response = await dio.get('$baseUrl/jobvacancy/$id');
    return JobVacancyModel.fromJson(response.data);
  }

  @override
  Future<void> addJobVacancy(JobVacancyModel jobVacancy) async {
    await dio.post('/jobvacancy', data: jobVacancy.toJson());
  }

  @override
  Future<void> updateJobVacancy(JobVacancyModel jobVacancy) async {
    await dio.put('$baseUrl/jobvacancy/${jobVacancy.id}',
        data: jobVacancy.toJson());
  }

  @override
  Future<void> deleteJobVacancy(String id) async {
    await dio.delete('$baseUrl/jobvacancy/$id');
  }
}
