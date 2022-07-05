// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `New User ?`
  String get New_User {
    return Intl.message(
      'New User ?',
      name: 'New_User',
      desc: '',
      args: [],
    );
  }

  /// `Register now to continue`
  String get Register_now_to_continue {
    return Intl.message(
      'Register now to continue',
      name: 'Register_now_to_continue',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get Full_name {
    return Intl.message(
      'Full Name',
      name: 'Full_name',
      desc: '',
      args: [],
    );
  }

  /// `Email Address`
  String get Email_address {
    return Intl.message(
      'Email Address',
      name: 'Email_address',
      desc: '',
      args: [],
    );
  }

  /// `Select Gender`
  String get Select_Gender {
    return Intl.message(
      'Select Gender',
      name: 'Select_Gender',
      desc: '',
      args: [],
    );
  }

  /// `Male`
  String get male {
    return Intl.message(
      'Male',
      name: 'male',
      desc: '',
      args: [],
    );
  }

  /// `Female`
  String get female {
    return Intl.message(
      'Female',
      name: 'female',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get Phone_Number {
    return Intl.message(
      'Phone Number',
      name: 'Phone_Number',
      desc: '',
      args: [],
    );
  }

  /// `Register now`
  String get Register_Now {
    return Intl.message(
      'Register now',
      name: 'Register_Now',
      desc: '',
      args: [],
    );
  }

  /// `We'll send you verification code on above given number to verify`
  String get Well_Send_You_Verification_Code_On_Above_Given_Number_To {
    return Intl.message(
      'We\'ll send you verification code on above given number to verify',
      name: 'Well_Send_You_Verification_Code_On_Above_Given_Number_To',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Forgot ?`
  String get forgot {
    return Intl.message(
      'Forgot ?',
      name: 'forgot',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get signIn {
    return Intl.message(
      'Sign in',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  /// `or continue with`
  String get or_Continue_With {
    return Intl.message(
      'or continue with',
      name: 'or_Continue_With',
      desc: '',
      args: [],
    );
  }

  /// `Facebook`
  String get facebook {
    return Intl.message(
      'Facebook',
      name: 'facebook',
      desc: '',
      args: [],
    );
  }

  /// `Google`
  String get google {
    return Intl.message(
      'Google',
      name: 'google',
      desc: '',
      args: [],
    );
  }

  /// `Verification`
  String get verification {
    return Intl.message(
      'Verification',
      name: 'verification',
      desc: '',
      args: [],
    );
  }

  /// `Add verificationCode send to your number`
  String get add_Verificationcode_Send_To_Your_Number {
    return Intl.message(
      'Add verificationCode send to your number',
      name: 'add_Verificationcode_Send_To_Your_Number',
      desc: '',
      args: [],
    );
  }

  /// `Verify Now`
  String get verify_Now {
    return Intl.message(
      'Verify Now',
      name: 'verify_Now',
      desc: '',
      args: [],
    );
  }

  /// `0:48 min left`
  String get xxx_Min_Left {
    return Intl.message(
      '0:48 min left',
      name: 'xxx_Min_Left',
      desc: '',
      args: [],
    );
  }

  /// `Resend`
  String get resend {
    return Intl.message(
      'Resend',
      name: 'resend',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get forgot_Password {
    return Intl.message(
      'Forgot Password?',
      name: 'forgot_Password',
      desc: '',
      args: [],
    );
  }

  /// `Enter Registered email and we will guide you to reset your password`
  String get enterRegisteredEmailAndWeWillGuideYouToReset {
    return Intl.message(
      'Enter Registered email and we will guide you to reset your password',
      name: 'enterRegisteredEmailAndWeWillGuideYouToReset',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `Enter your Email Address`
  String get enter_Your_Email_Address {
    return Intl.message(
      'Enter your Email Address',
      name: 'enter_Your_Email_Address',
      desc: '',
      args: [],
    );
  }

  /// `My Profile`
  String get my_Profile {
    return Intl.message(
      'My Profile',
      name: 'my_Profile',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Profile Info`
  String get profile_Info {
    return Intl.message(
      'Profile Info',
      name: 'profile_Info',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get username {
    return Intl.message(
      'Username',
      name: 'username',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Email Address`
  String get emailAddress {
    return Intl.message(
      'Email Address',
      name: 'emailAddress',
      desc: '',
      args: [],
    );
  }

  /// `Gender`
  String get gender {
    return Intl.message(
      'Gender',
      name: 'gender',
      desc: '',
      args: [],
    );
  }

  /// `samanthasmith@mail.com`
  String get samanthasmithmailcom {
    return Intl.message(
      'samanthasmith@mail.com',
      name: 'samanthasmithmailcom',
      desc: '',
      args: [],
    );
  }

  /// `samantha_smith`
  String get samanthasmith {
    return Intl.message(
      'samantha_smith',
      name: 'samanthasmith',
      desc: '',
      args: [],
    );
  }

  /// `Samantha Smith`
  String get samanthaSmith {
    return Intl.message(
      'Samantha Smith',
      name: 'samanthaSmith',
      desc: '',
      args: [],
    );
  }

  /// `Kevin Taylor`
  String get kevinTaylor {
    return Intl.message(
      'Kevin Taylor',
      name: 'kevinTaylor',
      desc: '',
      args: [],
    );
  }

  /// `Yes, that was awesome !!`
  String get yesThatWasAwesome {
    return Intl.message(
      'Yes, that was awesome !!',
      name: 'yesThatWasAwesome',
      desc: '',
      args: [],
    );
  }

  /// `2 mins ago`
  String get twoMinsAgo {
    return Intl.message(
      '2 mins ago',
      name: 'twoMinsAgo',
      desc: '',
      args: [],
    );
  }

  /// `Awesome Friends`
  String get awesomeFriends {
    return Intl.message(
      'Awesome Friends',
      name: 'awesomeFriends',
      desc: '',
      args: [],
    );
  }

  /// `Yeah, lets meet up !!`
  String get yeahLetsMeetUp {
    return Intl.message(
      'Yeah, lets meet up !!',
      name: 'yeahLetsMeetUp',
      desc: '',
      args: [],
    );
  }

  /// `Select member`
  String get selectMember {
    return Intl.message(
      'Select member',
      name: 'selectMember',
      desc: '',
      args: [],
    );
  }

  /// `Aron Smith`
  String get aronSmith {
    return Intl.message(
      'Aron Smith',
      name: 'aronSmith',
      desc: '',
      args: [],
    );
  }

  /// `iamaronsmith`
  String get iamaronsmith {
    return Intl.message(
      'iamaronsmith',
      name: 'iamaronsmith',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Hello Everyone`
  String get helloEveryone {
    return Intl.message(
      'Hello Everyone',
      name: 'helloEveryone',
      desc: '',
      args: [],
    );
  }

  /// `Emili Williamson`
  String get emiliWilliamson {
    return Intl.message(
      'Emili Williamson',
      name: 'emiliWilliamson',
      desc: '',
      args: [],
    );
  }

  /// `Hey Emili !`
  String get heyEmili {
    return Intl.message(
      'Hey Emili !',
      name: 'heyEmili',
      desc: '',
      args: [],
    );
  }

  /// `John Taylor`
  String get johnTaylor {
    return Intl.message(
      'John Taylor',
      name: 'johnTaylor',
      desc: '',
      args: [],
    );
  }

  /// `You`
  String get you {
    return Intl.message(
      'You',
      name: 'you',
      desc: '',
      args: [],
    );
  }

  /// `Samantha ! I must say, your pictures are so beautiful.`
  String get samanthaIMustSayYourPicturesAreSoBeautiful {
    return Intl.message(
      'Samantha ! I must say, your pictures are so beautiful.',
      name: 'samanthaIMustSayYourPicturesAreSoBeautiful',
      desc: '',
      args: [],
    );
  }

  /// `Oh, thanks John`
  String get ohThanksJohn {
    return Intl.message(
      'Oh, thanks John',
      name: 'ohThanksJohn',
      desc: '',
      args: [],
    );
  }

  /// `Hey friends!\nGood to see you all.`
  String get heyFriendsngoodToSeeYouAll {
    return Intl.message(
      'Hey friends!\nGood to see you all.',
      name: 'heyFriendsngoodToSeeYouAll',
      desc: '',
      args: [],
    );
  }

  /// `Write your comment`
  String get writeYourComment {
    return Intl.message(
      'Write your comment',
      name: 'writeYourComment',
      desc: '',
      args: [],
    );
  }

  /// `Group Info`
  String get groupInfo {
    return Intl.message(
      'Group Info',
      name: 'groupInfo',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Hangout friend's group`
  String get hangoutFriendsGroup {
    return Intl.message(
      'Hangout friend\'s group',
      name: 'hangoutFriendsGroup',
      desc: '',
      args: [],
    );
  }

  /// `Mute Notification`
  String get muteNotification {
    return Intl.message(
      'Mute Notification',
      name: 'muteNotification',
      desc: '',
      args: [],
    );
  }

  /// `Media Shared`
  String get mediaShared {
    return Intl.message(
      'Media Shared',
      name: 'mediaShared',
      desc: '',
      args: [],
    );
  }

  /// `View All`
  String get viewAll {
    return Intl.message(
      'View All',
      name: 'viewAll',
      desc: '',
      args: [],
    );
  }

  /// `Members in group(06)`
  String get membersInGroup06 {
    return Intl.message(
      'Members in group(06)',
      name: 'membersInGroup06',
      desc: '',
      args: [],
    );
  }

  /// `Add Group Name`
  String get addGroupName {
    return Intl.message(
      'Add Group Name',
      name: 'addGroupName',
      desc: '',
      args: [],
    );
  }

  /// `Add a brief description`
  String get addABriefDescription {
    return Intl.message(
      'Add a brief description',
      name: 'addABriefDescription',
      desc: '',
      args: [],
    );
  }

  /// `Create Group`
  String get createGroup {
    return Intl.message(
      'Create Group',
      name: 'createGroup',
      desc: '',
      args: [],
    );
  }

  /// `Today 10.00 am`
  String get today1000Am {
    return Intl.message(
      'Today 10.00 am',
      name: 'today1000Am',
      desc: '',
      args: [],
    );
  }

  /// `1.2k`
  String get onepointtwok {
    return Intl.message(
      '1.2k',
      name: 'onepointtwok',
      desc: '',
      args: [],
    );
  }

  /// `8.2k`
  String get eightpointtwok {
    return Intl.message(
      '8.2k',
      name: 'eightpointtwok',
      desc: '',
      args: [],
    );
  }

  /// `liked`
  String get liked {
    return Intl.message(
      'liked',
      name: 'liked',
      desc: '',
      args: [],
    );
  }

  /// `your post`
  String get yourPost {
    return Intl.message(
      'your post',
      name: 'yourPost',
      desc: '',
      args: [],
    );
  }

  /// `Create Post`
  String get createPost {
    return Intl.message(
      'Create Post',
      name: 'createPost',
      desc: '',
      args: [],
    );
  }

  /// `Say something about this photo`
  String get saySomethingAboutThisPhoto {
    return Intl.message(
      'Say something about this photo',
      name: 'saySomethingAboutThisPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Write something to post`
  String get writeSomethingToPost {
    return Intl.message(
      'Write something to post',
      name: 'writeSomethingToPost',
      desc: '',
      args: [],
    );
  }

  /// `Submit Post`
  String get submitPost {
    return Intl.message(
      'Submit Post',
      name: 'submitPost',
      desc: '',
      args: [],
    );
  }

  /// `Swipe up for gallery`
  String get swipeUpForGallery {
    return Intl.message(
      'Swipe up for gallery',
      name: 'swipeUpForGallery',
      desc: '',
      args: [],
    );
  }

  /// `Swipe up to see next`
  String get swipeUpToSeeNext {
    return Intl.message(
      'Swipe up to see next',
      name: 'swipeUpToSeeNext',
      desc: '',
      args: [],
    );
  }

  /// `Hey,`
  String get hey {
    return Intl.message(
      'Hey,',
      name: 'hey',
      desc: '',
      args: [],
    );
  }

  /// `View Profile`
  String get viewProfile {
    return Intl.message(
      'View Profile',
      name: 'viewProfile',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profile`
  String get editProfile {
    return Intl.message(
      'Edit Profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `Change Language`
  String get changeLanguage {
    return Intl.message(
      'Change Language',
      name: 'changeLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Hello, there?`
  String get helloThere {
    return Intl.message(
      'Hello, there?',
      name: 'helloThere',
      desc: '',
      args: [],
    );
  }

  /// `How you doing?`
  String get howYouDoing {
    return Intl.message(
      'How you doing?',
      name: 'howYouDoing',
      desc: '',
      args: [],
    );
  }

  /// `Hey, wassup?`
  String get heyWassup {
    return Intl.message(
      'Hey, wassup?',
      name: 'heyWassup',
      desc: '',
      args: [],
    );
  }

  /// `Isn't this app amazing?`
  String get isntThisAppAmazing {
    return Intl.message(
      'Isn\'t this app amazing?',
      name: 'isntThisAppAmazing',
      desc: '',
      args: [],
    );
  }

  /// `Its so cool that I can chat with my friend's friends.`
  String get itsSoCoolThatICanChatWithMyFriends {
    return Intl.message(
      'Its so cool that I can chat with my friend\'s friends.',
      name: 'itsSoCoolThatICanChatWithMyFriends',
      desc: '',
      args: [],
    );
  }

  /// `12:07 am`
  String get am1207 {
    return Intl.message(
      '12:07 am',
      name: 'am1207',
      desc: '',
      args: [],
    );
  }

  /// `Finding Myself !!`
  String get findingMyself {
    return Intl.message(
      'Finding Myself !!',
      name: 'findingMyself',
      desc: '',
      args: [],
    );
  }

  /// `Rose Kelly`
  String get roseKelly {
    return Intl.message(
      'Rose Kelly',
      name: 'roseKelly',
      desc: '',
      args: [],
    );
  }

  /// `Wow. Looks stunning :)`
  String get wowLooksStunning {
    return Intl.message(
      'Wow. Looks stunning :)',
      name: 'wowLooksStunning',
      desc: '',
      args: [],
    );
  }

  /// `Write comment here`
  String get writeCommentHere {
    return Intl.message(
      'Write comment here',
      name: 'writeCommentHere',
      desc: '',
      args: [],
    );
  }

  /// `Following`
  String get following {
    return Intl.message(
      'Following',
      name: 'following',
      desc: '',
      args: [],
    );
  }

  /// `Trending`
  String get trending {
    return Intl.message(
      'Trending',
      name: 'trending',
      desc: '',
      args: [],
    );
  }

  /// `Style`
  String get style {
    return Intl.message(
      'Style',
      name: 'style',
      desc: '',
      args: [],
    );
  }

  /// `Travel`
  String get travel {
    return Intl.message(
      'Travel',
      name: 'travel',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message(
      'All',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `Likes`
  String get likes {
    return Intl.message(
      'Likes',
      name: 'likes',
      desc: '',
      args: [],
    );
  }

  /// `Comments`
  String get comments {
    return Intl.message(
      'Comments',
      name: 'comments',
      desc: '',
      args: [],
    );
  }

  /// `Repost`
  String get repost {
    return Intl.message(
      'Repost',
      name: 'repost',
      desc: '',
      args: [],
    );
  }

  /// `Friends`
  String get friends {
    return Intl.message(
      'Friends',
      name: 'friends',
      desc: '',
      args: [],
    );
  }

  /// `Groups`
  String get groups {
    return Intl.message(
      'Groups',
      name: 'groups',
      desc: '',
      args: [],
    );
  }

  /// `Stories`
  String get stories {
    return Intl.message(
      'Stories',
      name: 'stories',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Chats`
  String get chats {
    return Intl.message(
      'Chats',
      name: 'chats',
      desc: '',
      args: [],
    );
  }

  /// `Follower`
  String get follower {
    return Intl.message(
      'Follower',
      name: 'follower',
      desc: '',
      args: [],
    );
  }

  /// `@iamemiliwilliamson`
  String get iamemiliwilliamson {
    return Intl.message(
      '@iamemiliwilliamson',
      name: 'iamemiliwilliamson',
      desc: '',
      args: [],
    );
  }

  /// `Posts`
  String get posts {
    return Intl.message(
      'Posts',
      name: 'posts',
      desc: '',
      args: [],
    );
  }

  /// `Saved`
  String get saved {
    return Intl.message(
      'Saved',
      name: 'saved',
      desc: '',
      args: [],
    );
  }

  /// `Photo`
  String get photo {
    return Intl.message(
      'Photo',
      name: 'photo',
      desc: '',
      args: [],
    );
  }

  /// `Video`
  String get video {
    return Intl.message(
      'Video',
      name: 'video',
      desc: '',
      args: [],
    );
  }

  /// `Gallery`
  String get gallery {
    return Intl.message(
      'Gallery',
      name: 'gallery',
      desc: '',
      args: [],
    );
  }

  /// `Message`
  String get message {
    return Intl.message(
      'Message',
      name: 'message',
      desc: '',
      args: [],
    );
  }

  /// `Follow`
  String get follow {
    return Intl.message(
      'Follow',
      name: 'follow',
      desc: '',
      args: [],
    );
  }

  /// `Select Language`
  String get selectLanguage {
    return Intl.message(
      'Select Language',
      name: 'selectLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Opps something went wrong. Please try again later.`
  String get oppsSomethingWentWrongPleaseTryAgainLater {
    return Intl.message(
      'Opps something went wrong. Please try again later.',
      name: 'oppsSomethingWentWrongPleaseTryAgainLater',
      desc: '',
      args: [],
    );
  }

  /// `Buy Now`
  String get buyNow {
    return Intl.message(
      'Buy Now',
      name: 'buyNow',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'id'),
      Locale.fromSubtags(languageCode: 'it'),
      Locale.fromSubtags(languageCode: 'pt'),
      Locale.fromSubtags(languageCode: 'sw'),
      Locale.fromSubtags(languageCode: 'tr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
