import 'package:silesra/features/Job/data/model/job_vacancy.dart';
import 'package:silesra/features/Job/data/remote_data/remote_data_job.dart';

abstract class JobVacancyRepository {
  Future<List<JobVacancyModel>> getJobVacancies({required int page, required int pageSize});
  Future<JobVacancyModel> getJobVacancyById(String id);
  Future<void> addJobVacancy(JobVacancyModel jobVacancy);
  Future<void> updateJobVacancy(JobVacancyModel jobVacancy);
  Future<void> deleteJobVacancy(String id);
}

class JobVacancyRepositoryImpl implements JobVacancyRepository {
  final JobVacancyRemoteDataSource remoteDataSource;

  JobVacancyRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<JobVacancyModel>> getJobVacancies({int page = 1, int pageSize = 10}) async {
    return await remoteDataSource.getJobVacancies();
  }

  @override
  Future<JobVacancyModel> getJobVacancyById(String id) async {
    return await remoteDataSource.getJobVacancyById(id);
  }

  @override
  Future<void> addJobVacancy(JobVacancyModel jobVacancy) async {
    return await remoteDataSource.addJobVacancy(jobVacancy);
  }

  @override
  Future<void> updateJobVacancy(JobVacancyModel jobVacancy) async {
    return await remoteDataSource.updateJobVacancy(jobVacancy);
  }

  @override
  Future<void> deleteJobVacancy(String id) async {
    return await remoteDataSource.deleteJobVacancy(id);
  }
}
