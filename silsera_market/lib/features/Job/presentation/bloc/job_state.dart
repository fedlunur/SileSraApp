import 'package:silesra/features/Job/data/model/job_vacancy.dart';

abstract class JobVacancyState {}

class JobVacancyInitial extends JobVacancyState {}

class JobVacancyLoading extends JobVacancyState {}

class JobVacancyLoaded extends JobVacancyState {
  final List<JobVacancyModel> jobVacancies;
  final bool hasReachedMax;

  JobVacancyLoaded({
    required this.jobVacancies,
    this.hasReachedMax = false,
  });

  JobVacancyLoaded copyWith({
    List<JobVacancyModel>? jobVacancies,
    bool? hasReachedMax,
  }) {
    return JobVacancyLoaded(
      jobVacancies: jobVacancies ?? this.jobVacancies,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class JobVacancyDetailLoaded extends JobVacancyState {
  final JobVacancyModel jobVacancy;
  JobVacancyDetailLoaded(this.jobVacancy);
}

class JobVacancyError extends JobVacancyState {
  final String message;
  JobVacancyError(this.message);
}

class JobVacancyPaginationError extends JobVacancyState {
  final String message;
  JobVacancyPaginationError(this.message);
}
