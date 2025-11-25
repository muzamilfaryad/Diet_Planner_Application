# Security Policy

## Supported Versions

We actively support the following versions of the Diet Planner Application:

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

We take the security of Diet Planner Application seriously. If you believe you have found a security vulnerability, please report it to us responsibly.

### How to Report

**Please do NOT report security vulnerabilities through public GitHub issues.**

Instead, please report them via one of the following methods:

1. **Email**: Contact the maintainer directly through GitHub
2. **Private Security Advisory**: Use GitHub's private vulnerability reporting feature

### What to Include

When reporting a vulnerability, please include:

- **Type of vulnerability** (e.g., XSS, SQL injection, authentication bypass)
- **Full paths** of source file(s) related to the vulnerability
- **Location** of the affected source code (tag/branch/commit or direct URL)
- **Step-by-step instructions** to reproduce the issue
- **Proof-of-concept or exploit code** (if possible)
- **Impact** of the vulnerability
- **Potential solutions** (if you have any ideas)

### What to Expect

- **Acknowledgment**: Within 48 hours of your report
- **Initial Assessment**: Within 5 business days
- **Regular Updates**: Every 5-7 days on the status
- **Disclosure Timeline**: Coordinated with you after the fix is released

### Responsible Disclosure

We ask that you:

- Give us reasonable time to investigate and fix the issue before public disclosure
- Make a good faith effort to avoid privacy violations, data destruction, and service disruption
- Do not exploit the vulnerability beyond what is necessary to demonstrate it

### Bug Bounty

Currently, we do not offer a paid bug bounty program. However, we will:

- Publicly acknowledge your responsible disclosure (if you wish)
- Credit you in the release notes
- Add you to our security contributors list

## Security Best Practices for Users

### API Keys & Secrets

- **Never commit** API keys or secrets to version control
- Use **environment variables** or secure configuration management
- Enable **Firebase security rules** for production deployments
- Regularly **rotate API keys**

### Firebase Security

1. **Update Security Rules**:
   - Use production rules from `docs/setup/FIRESTORE_SECURITY_RULES.txt`
   - Never use test mode rules in production
   - Regularly review and update rules

2. **Authentication**:
   - Enable only necessary auth providers
   - Use strong password requirements
   - Enable email verification for new accounts
   - Implement rate limiting for auth attempts

3. **Data Protection**:
   - Enable Firestore backup and recovery
   - Use Firebase App Check to prevent abuse
   - Monitor usage through Firebase Console
   - Set appropriate data retention policies

### Application Security

1. **Dependencies**:
   - Keep Flutter SDK and packages up to date
   - Run `flutter pub outdated` regularly
   - Review package vulnerabilities before updates

2. **Code Security**:
   - Validate all user inputs
   - Sanitize data before displaying
   - Use parameterized queries for API calls
   - Implement proper error handling (don't leak sensitive info)

3. **Build Security**:
   - Use ProGuard/R8 for Android release builds
   - Enable code obfuscation for production
   - Remove debug code and logging in production
   - Sign APKs/IPAs with secure keys

### User Data Privacy

- **Minimal Data Collection**: Only collect necessary data
- **Data Encryption**: Sensitive data encrypted at rest and in transit
- **User Consent**: Clear privacy policy and consent mechanisms
- **Data Deletion**: Honor user data deletion requests
- **GDPR Compliance**: Follow data protection regulations

## Known Security Considerations

### Current Implementation

1. **API Keys**: Currently stored in code (development)
   - **Production**: Move to secure environment configuration
   - **Recommendation**: Use Flutter's `--dart-define` or `flutter_dotenv`

2. **Firebase**: Using email/password and Google Sign-In
   - **Security**: Implement email verification
   - **Enhancement**: Add 2FA support in future

3. **Data Storage**: Firestore with user-specific collections
   - **Security**: Security rules implemented
   - **Enhancement**: Enable backup and disaster recovery

### Planned Security Enhancements

- [ ] Implement email verification for new accounts
- [ ] Add two-factor authentication (2FA)
- [ ] Implement rate limiting on API calls
- [ ] Add Firebase App Check for abuse prevention
- [ ] Automated dependency vulnerability scanning
- [ ] Security audit before major releases
- [ ] Implement data encryption for sensitive fields
- [ ] Add security headers for web deployment

## Security Updates

Security updates will be released as soon as possible after a vulnerability is confirmed. Users will be notified through:

- GitHub Security Advisories
- Release notes in CHANGELOG.md
- GitHub Releases page
- Project README updates

## Compliance

This project aims to comply with:

- **OWASP Mobile Security** guidelines
- **GDPR** (General Data Protection Regulation)
- **CCPA** (California Consumer Privacy Act)
- **Firebase Security Best Practices**
- **Flutter Security Best Practices**

## Contact

For security-related inquiries that don't concern a vulnerability, please contact through:

- GitHub Issues (for general security questions)
- GitHub Discussions (for security best practices)

## Acknowledgments

We would like to thank the following individuals for responsibly disclosing security vulnerabilities:

- *No vulnerabilities reported yet*

---

**Last Updated**: November 9, 2024

For general security questions, see our [Contributing Guide](CONTRIBUTING.md) or open a [Discussion](https://github.com/muzamilfaryad/Diet_Planner_Application/discussions).
