part of 'monthly_cubit.dart';

@immutable
abstract class MonthlyState {}

class MonthlyInitial extends MonthlyState {}


class MonthlyLoading extends MonthlyState{}
class MonthlySuccess extends MonthlyState{}
class MonthlyField extends MonthlyState{}



class PrintingMonthlyLoading extends MonthlyState{}
class PrintingMonthlySuccess extends MonthlyState{}
class PrintingMonthlyField extends MonthlyState{}
class PrintingMonthlyFinish extends MonthlyState{}




class PrintingFinishMonthly extends MonthlyState{}
class KillFinishMonthly extends MonthlyState{}
class KillFinishErrorMonthly extends MonthlyState{}
class getIpsMonthly extends MonthlyState{}

