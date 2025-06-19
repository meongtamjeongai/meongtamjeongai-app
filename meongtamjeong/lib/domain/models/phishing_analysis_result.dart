class PhishingAnalysisResult {
  final int phishingScore;
  final String reason;

  PhishingAnalysisResult({required this.phishingScore, required this.reason});

  factory PhishingAnalysisResult.fromJson(Map<String, dynamic> json) {
    return PhishingAnalysisResult(
      phishingScore: json['phishing_score'] as int,
      reason: json['reason'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'phishing_score': phishingScore, 'reason': reason};
  }
}
