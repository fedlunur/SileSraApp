import 'package:silesra/features/Job/data/model/job_vacancy.dart';
import 'package:silesra/features/Job/domain/repo.dart';

class GetJobVacancies {
  final JobVacancyRepository repository;

  GetJobVacancies(this.repository);

  Future<List<JobVacancyModel>> call({required int page, required int pageSize}) async {
    return await repository.getJobVacancies(page: page, pageSize: pageSize);
  }
}

class GetJobVacancyById {
  final JobVacancyRepository repository;

  GetJobVacancyById(this.repository);

  Future<JobVacancyModel> call(String id) async {
    return await repository.getJobVacancyById(id);
  }
}

class AddJobVacancy {
  final JobVacancyRepository repository;

  AddJobVacancy(this.repository);

  Future<void> call(JobVacancyModel jobVacancy) async {
    await repository.addJobVacancy(jobVacancy);
  }
}

class UpdateJobVacancy {
  final JobVacancyRepository repository;

  UpdateJobVacancy(this.repository);

  Future<void> call(JobVacancyModel jobVacancy) async {
    await repository.updateJobVacancy(jobVacancy);
  }
}

class DeleteJobVacancy {
  final JobVacancyRepository repository;

  DeleteJobVacancy(this.repository);

  Future<void> call(String id) async {
    await repository.deleteJobVacancy(id);
  }
}
