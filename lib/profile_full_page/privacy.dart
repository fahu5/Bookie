import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  final String privacyPolicyText = '''
Privacy Policy

Last Updated: [13.05.2024]

Introduction

Welcome to Bookie. At Bookie, we are committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our App. Please read this Privacy Policy carefully. If you do not agree with the terms of this Privacy Policy, please do not access the App.

1. Information We Collect

We may collect information about you in a variety of ways. The information we may collect via the App includes:

Personal Data

While using our App, we may ask you to provide us with certain personally identifiable information that can be used to contact or identify you ("Personal Data"). This may include, but is not limited to:
- Name
- Email address
- Profile picture
- User preferences and settings

Usage Data

We may also collect information that your device sends whenever you use our App ("Usage Data"). This Usage Data may include information such as your device's Internet Protocol (IP) address, device type, operating system, the pages of our App that you visit, the time and date of your visit, the time spent on those pages, unique device identifiers, and other diagnostic data.

Cookies and Tracking Technologies

We use cookies and similar tracking technologies to track the activity on our App and store certain information. Cookies are files with a small amount of data which may include an anonymous unique identifier. You can instruct your browser to refuse all cookies or to indicate when a cookie is being sent. However, if you do not accept cookies, you may not be able to use some portions of our App.

2. Use of Your Information

We use the information we collect in the following ways:
- To provide, operate, and maintain our App
- To improve, personalize, and expand our App
- To understand and analyze how you use our App
- To develop new products, services, features, and functionality
- To communicate with you, either directly or through one of our partners, including for customer service, to provide you with updates and other information relating to the App, and for marketing and promotional purposes
- To process your transactions and manage your orders
- To find and prevent fraud
- To comply with legal obligations

3. Sharing of Your Information

We may share information we have collected about you in certain situations. Your information may be disclosed as follows:

With Service Providers

We may share your information with third-party vendors, service providers, contractors, or agents who perform services on our behalf, such as data analysis, payment processing, email delivery, hosting services, customer service, and marketing assistance.

For Business Transfers

We may share or transfer your information in connection with, or during negotiations of, any merger, sale of company assets, financing, or acquisition of all or a portion of our business to another company.

With Affiliates

We may share your information with our affiliates, in which case we will require those affiliates to honor this Privacy Policy.

With Business Partners

We may share your information with our business partners to offer you certain products, services, or promotions.

4. Security of Your Information

We use administrative, technical, and physical security measures to help protect your personal information. While we have taken reasonable steps to secure the personal information you provide to us, please be aware that despite our efforts, no security measures are perfect or impenetrable, and no method of data transmission can be guaranteed against any interception or other type of misuse.

5. Your Data Protection Rights

Depending on your location, you may have the following rights regarding your personal data:
- The right to access – You have the right to request copies of your personal data.
- The right to rectification – You have the right to request that we correct any information you believe is inaccurate or complete information you believe is incomplete.
- The right to erasure – You have the right to request that we erase your personal data, under certain conditions.
- The right to restrict processing – You have the right to request that we restrict the processing of your personal data, under certain conditions.
- The right to object to processing – You have the right to object to our processing of your personal data, under certain conditions.
- The right to data portability – You have the right to request that we transfer the data that we have collected to another organization, or directly to you, under certain conditions.

If you make a request, we have one month to respond to you. If you would like to exercise any of these rights, please contact us at our email: [Your Contact Email]

6. Changes to This Privacy Policy

We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page. You are advised to review this Privacy Policy periodically for any changes. Changes to this Privacy Policy are effective when they are posted on this page.

7. Contact Us

If you have any questions about this Privacy Policy, please contact us:
- By email: [Your Contact Email]
- By visiting this page on our website: [Your Contact Page URL]
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Text(
          privacyPolicyText,
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
