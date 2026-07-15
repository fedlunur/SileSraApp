import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silesra/features/Job/domain/job_usecase.dart';

import 'package:silesra/features/Job/presentation/bloc/job_event.dart';
import 'package:silesra/features/Job/presentation/bloc/job_state.dart';

class JobVacancyBloc extends Bloc<JobEvent, JobVacancyState> {
  final GetJobVacancies getJobVacancies;
  final AddJobVacancy addJobVacancy;
  final UpdateJobVacancy updateJobVacancy;
  final DeleteJobVacancy deleteJobVacancy;
  final GetJobVacancyById getJobVacancyById;

  int _currentPage = 1;
  static const int _pageSize = 10;
  bool _isFetching = false;

  JobVacancyBloc({
    required this.getJobVacancies,
    required this.addJobVacancy,
    required this.updateJobVacancy,
    required this.deleteJobVacancy,
    required this.getJobVacancyById,
  }) : super(JobVacancyInitial()) {
    on<FetchJobVacancies>(_onFetchJobVacancies);
    on<FetchMoreJobVacancies>(_onFetchMoreJobVacancies);
    on<FetchJobVacancyByIdEvent>(_onFetchJobVacancyById);
    on<AddJobVacancyEvent>(_onAddJobVacancy);
    on<UpdateJobVacancyEvent>(_onUpdateJobVacancy);
    on<DeleteJobVacancyEvent>(_onDeleteJobVacancy);
  }

  Future<void> _onFetchJobVacancies(
      FetchJobVacancies event, Emitter<JobVacancyState> emit) async {
    _currentPage = 1;
    emit(JobVacancyLoading());

    try {
      final jobs = await getJobVacancies(page: _currentPage, pageSize: _pageSize);
      emit(JobVacancyLoaded(
        jobVacancies: jobs,
        hasReachedMax: jobs.length < _pageSize,
      ));
      _currentPage++;
    } catch (e) {
      emit(JobVacancyError(e.toString()));
    }
  }

  Future<void> _onFetchMoreJobVacancies(
      FetchMoreJobVacancies event, Emitter<JobVacancyState> emit) async {
    if (state is JobVacancyLoaded) {
      final currentState = state as JobVacancyLoaded;

      if (currentState.hasReachedMax || _isFetching) return;

      _isFetching = true;

      try {
        final moreJobs = await getJobVacancies(page: _currentPage, pageSize: _pageSize);
        if (moreJobs.isEmpty) {
          emit(currentState.copyWith(hasReachedMax: true));
        } else {
          emit(currentState.copyWith(
            jobVacancies: currentState.jobVacancies + moreJobs,
            hasReachedMax: moreJobs.length < _pageSize,
          ));
          _currentPage++;
        }
      } catch (e) {
        emit(JobVacancyPaginationError(e.toString()));
      } finally {
        _isFetching = false;
      }
    }
  }

  Future<void> _onAddJobVacancy(
      AddJobVacancyEvent event, Emitter<JobVacancyState> emit) async {
    emit(JobVacancyLoading());
    try {
      await addJobVacancy(event.jobVacancy);
      add(FetchJobVacancies()); // Refresh list after adding
    } catch (e) {
      emit(JobVacancyError(e.toString()));
    }
  }

  Future<void> _onUpdateJobVacancy(
      UpdateJobVacancyEvent event, Emitter<JobVacancyState> emit) async {
    emit(JobVacancyLoading());
    try {
      await updateJobVacancy(event.jobVacancy);
      add(FetchJobVacancies()); // Refresh list after update
    } catch (e) {
      emit(JobVacancyError(e.toString()));
    }
  }

  Future<void> _onDeleteJobVacancy(
      DeleteJobVacancyEvent event, Emitter<JobVacancyState> emit) async {
    emit(JobVacancyLoading());
    try {
      await deleteJobVacancy(event.id);
      add(FetchJobVacancies()); // Refresh list after delete
    } catch (e) {
      emit(JobVacancyError(e.toString()));
    }
  }

  Future<void> _onFetchJobVacancyById(
      FetchJobVacancyByIdEvent event, Emitter<JobVacancyState> emit) async {
    emit(JobVacancyLoading());
    try {
      final job = await getJobVacancyById(event.id);
      emit(JobVacancyDetailLoaded(job));
    } catch (e) {
      emit(JobVacancyError(e.toString()));
    }
  }
}
