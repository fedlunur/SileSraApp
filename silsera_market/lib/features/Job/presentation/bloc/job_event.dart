import 'package:silesra/features/Job/data/model/job_vacancy.dart';

abstract class JobEvent {}

class FetchJobVacancies extends JobEvent {}

class FetchMoreJobVacancies extends JobEvent {}

class FetchJobVacancyByIdEvent extends JobEvent {
  final String id;
  FetchJobVacancyByIdEvent(this.id);
}

class AddJobVacancyEvent extends JobEvent {
  final JobVacancyModel jobVacancy;
  AddJobVacancyEvent(this.jobVacancy);
}

class UpdateJobVacancyEvent extends JobEvent {
  final JobVacancyModel jobVacancy;
  UpdateJobVacancyEvent(this.jobVacancy);
}

class DeleteJobVacancyEvent extends JobEvent {
  final String id;
  DeleteJobVacancyEvent(this.id);
}
