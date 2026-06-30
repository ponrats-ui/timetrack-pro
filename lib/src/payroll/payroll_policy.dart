import '../features/settings/domain/work_settings.dart';
import '../features/time_records/domain/work_record.dart';
import 'company_policy.dart';
import 'custom_policy.dart';
import 'thai_labour_policy.dart';

abstract class PayrollPolicy {
  const PayrollPolicy();

  double normalMultiplier(PayrollRules rules, DayType dayType);

  double overtimeMultiplier(PayrollRules rules, DayType dayType);
}

class PayrollPolicyFactory {
  const PayrollPolicyFactory();

  PayrollPolicy create(PayrollPolicyType type) {
    return switch (type) {
      PayrollPolicyType.thaiLabour => const ThaiLabourPolicy(),
      PayrollPolicyType.company => const CompanyPolicy(),
      PayrollPolicyType.custom => const CustomPolicy(),
    };
  }
}
