import 'package:get/get.dart';

class LocaleChange extends Translations {
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'unit_title': 'Unit',
          'reverseArabicOption': 'Reverse Arabic Option',
          'usbPrinter': 'USB Printer',
          'bluetoothPrinter': 'Bluetooth Printer',
          'select_printer_type': 'Select Printer Type',
          'select_branch': 'Select your branch',
          'is_Arabic': 'Arabic',
          'Verify_your_account': 'Verify your account',
          'Email': 'Email',
          'enter_the_otp': 'Enter the OTP',
          'resend_opt': 'Resend OTP',
          'please_enter_email': 'Please enter valid email',
          'please_enter_otp': 'Please enter otp',
          'create_vikn_acnt': 'Create your Vikn account',
          'username': 'Username',
          'verification': 'This will be used for verification.',
          'country': 'Country',
          'phone': 'Phone',
          'msg': 'Use 8 or more characters with a mix of letters, numbers & symbols.',
          'sign_in_instead': 'Sign in instead.',
          'first_name': 'First name',
          'second_name': 'Second name',
          'Password': 'Password',
          'confirm_password': 'Confirm Password',
          'choose_a_country': 'Choose a country',
          'sign_in_vikn_account': 'Sign in with Vikn account',
          'forgot_account': 'Forgotten password?',
          'or': 'or',
          'create_an_accnt': 'Create an account',
          'please_enter_details': 'Please enter user details',
          'user_or_email': 'Username or email',
          'go_back': 'Go back',
          'please_enter_email_username': 'Please enter username or email',
          'Profile': 'Profile',
          'msg1': 'if you delete account once, you wont be able to retrieve your information',
          'msg2': 'Please accept terms and condition',
          'dlt_acnt': 'Delete Account',
          'enter_pin': 'Enter PIN',
          'call_us': 'Call Us',
          'route': 'Route',
          'tax_type': 'Tax Type',
          'cam': 'Camera',
          'gall': 'Gallery',
          'customer': 'Customer',
          'search': 'Search',
          'delete_msg': 'Delete Confirmation',
          'msg4': 'Are you sure you want to delete this item?',
          'dlt': 'Delete',
          'cancel': 'Cancel',
          'no_network': 'No Internet Connection',
          'retry': 'Retry',
          'Ok': 'Ok',
          'select_date': 'Select Date',
          'Invoices': 'Invoices',
          'from': 'From :',
          'to': 'To :',
          'token_no': 'Token No',
          'loyalty_cust': 'Loyalty Customers',
          'name': 'Name:',
          'phone1': 'Phone:',
          'loc': 'Location:',
          'card_type': 'Card Type:',
          'card_no': 'Card No:',
          'Status': 'Status',
          'msg_loylty': 'Select a Loyalty Customer',
          'add_loyalty': 'Add Loyalty',
          'card_type1': 'Card Type',
          'delivery_man': 'Delivery man',
          'select_customer': 'Select Customer',
          'payment': 'Payment',
          'select_delivery_man': 'Select Delivery man',
          'balance': 'Balance :',
          'to_be_paid': 'To be paid',
          'total_tax': 'Total tax',
          'net_total': 'Net total',
          'grand_total': 'Grand total',
          'cash': 'Cash',
          'tot_cash': 'Total Cash:',
          'full_cash': 'Full in cash',
          'bank': 'Bank',
          'amt': 'Amount:',
          'pay_full': 'Pay Full',
          'disc': 'Discount:',
          'print_save': 'Print&Save',
          'save': 'Save',
          'choose_item': 'Choose Items',
          'cus_name': 'Customer name',
          'ph_no': 'Phone No',
          'code': 'Code',
          'description': 'Description',
          'add_item': 'Add item',
          'veg_only': 'Veg Only',
          'Yes': 'Yes',
          'Dining': 'Dining',
          'choose_table': 'Choose a Table',
          'Refresh': 'Refresh',
          'add_table': 'Add table',
          'Reservation': 'Reservation',
          'Category': 'Category',
          'No_Cat': 'No Category',
          'no_tax': 'No Tax category',
          'msg5': 'No Image Selected!',
          'Product': 'Product',
          'edit_product': 'Edit Product',
          'add_product': 'Add Product',
          'pur_Price': 'Purchase Price',
          'select_product': 'Select a product',
          'veg': 'Veg',
          'non_veg': 'Non- Veg',
          'Group': 'Group',
          'sales_price': 'Sales Price',
          'tax': 'Tax',
          'Inclusive': 'Inclusive',
          'Kitchen': 'Kitchen',
          'no_kitchen': 'No Kitchen',
          'product_group': 'Product Group',
          'edit_product_grp': 'Edit Product Group',
          'add_product_grp': 'Add Product Group',
          'grp_name': 'Group Name:',
          'select_kitchen': 'Select Kitchen:',
          'des': 'Description:',
          'select_a_product_grp': 'Select a product group',
          'edit_tax': 'Edit Tax',
          'add_tax': 'Add Tax',
          'tax_name': 'Tax Name :',
          'sale_percent': 'Sales Percent:',
          'purchase_percent': 'Purchase Percent:',
          'select_tax': 'Select a Tax',
          'choose_country': 'Choose a Country',
          'choose_state': 'Choose a State',
          'create_org': 'Create Organization',
          'address_detail': 'Address Details',
          'build': 'Building No/Name',
          'landmark': 'Landmark',
          'City': 'City',
          'Required': 'Required',
          'postal_code': 'Postal code',
          'Next': 'Next',
          'org_profile': 'Organization Profile',
          'reg_no': 'Registration No',
          'financial_year': 'Financial Year',
          'tax_details': 'Tax Details',
          'tax_no': 'Tax Number',
          'zatca': 'Enable ZATCA Rule',
          'create_new_org': 'Create your New Organization',
          'create': 'Create',
          'select_org': 'Select an existing organization',
          'join': 'Join',
          'select_employee': 'Select employee',
          'no_emp': 'No Employee',
          'Report': 'Report',
          'report_type': 'Report Type',
          'get_rep': 'Get Report',
          'cash1': 'Cash :',
          'bank1': 'Bank :',
          'credit': 'Credit :',
          'grand_tot': 'Grand Total:',
          'total_sld': 'Total Sold:',
          'Daily_sum': 'Daily Summary',
          'particular': 'PARTICULARS',
          'CASH': 'CASH',
          'BANK': 'BANK',
          'CREDIT': 'CREDIT',
          'opn_blns': 'Opening Balance',
          'sales_invoice': 'Sales Invoice',
          'sales_return': 'Sales Return',
          'Purchase_Invoice': 'Purchase Invoice',
          'Purchase_Return': 'Purchase Return',
          'Expenses': 'Expenses',
          'Receipts': 'Receipts',
          'Journals': 'Journals',
          'closing_balance': 'Closing Balance',
          'sales_summary': 'Sales Invoice Summary',
          'Gross': 'Gross',
          'gross_amount': 'Gross Amount',
          'Total': 'Total',
          'sale_return_sum': 'Sales Return Summary',
          'Effective_Sale': 'Effective Sale',
          'Effective_Sale1': '#Effective Sale',
          'sale_invo': '#Sales Invoice',
          'sale_invoice': 'Sales Invoice',
          'sale_return': '#Sales Return',
          'Purchase': 'Purchase',
          'sale_byt_type': 'Sale By Type',
          'Take_awy': 'Take away',
          'Car': 'Car',
          'Order_Detailed': 'Order Detailed',
          'order': '#Orders',
          'amount': 'Amount',
          'Cancelled': 'Cancelled',
          'Pending': 'Pending',
          'ord_emp': 'Order By Employee',
          'Employee': 'Employee',
          '#Cancelled': '#Cancelled',
          'sales_emp': 'Sales By Employee',
          'Sales': 'Sales',
          '#Return': '#Return',
          'report_preview': 'Report preview',
          'Waiter': 'Waiter',
          'No_waiter': 'No Waiter',
          'select_printer': 'Select Printer',
          'select_capability': 'Select capabilities',
          'select_role': 'Select Role',
          'Settings': 'Settings',
          'KOT_log': 'KOT Log',
          'user_role': 'User Roles',
          'role_name': 'Role Name',
          'Role': 'Role',
          'Online': 'Online',
          'wifi_printer': 'Wifi printer',
          'select_temp': 'Select Template:',
          'sale_order': 'Sales Order',
          'set_def': 'Set default',
          'highlight_tkn_no': 'Highlighted Token Number',
          'payment_detail': 'Payment Details',
          'com_detail_align': 'Company Details Alignment',
          'gen_setting': 'General Settings',
          'printer_set': 'Printer Settings',
          'add_print': 'Add printer',
          'kit_set': 'Kitchen Settings',
          'contact_us': 'Contact Us',
          'privacy_policy': 'Privacy Policy',
          'terms_condition': 'Terms And Conditions',
          'vertion_detail': 'Version Details',
          'log_out': 'Log Out',
          'KOT_print': 'KOT print',
          'qty_inc': 'Quantity increment',
          'show_inv': 'Show invoice',
          'clear_table': 'Clear table after payment',
          'print_after_payment': 'Print after payment',
          'intial_tkn': 'Initial Token No',
          'com_hr': 'Compensation Hour',
          'Printers': 'Printers',
          'print_name': 'Printer Name',
          'kit_name': 'Kitchen Name',
          'kit_print': 'Kitchen Print',
          'set_both': 'Set both',
          'select_print': 'Select printer:',
          'Users': 'Users',
          'Generate': 'Generate',
          'New': 'New',
          'Add': 'Add',
          'kot_a_print': 'Kot a print',
          'custom_print': 'Customize Print',
          'reset_time': 'Token Reset Time',
          'waiter_pay': 'Waiter Can Pay',
          'Dashboard': 'Dashboard',
          'com_info': 'Company info',
          'user_log_out': 'User log out',
          'Products': 'Products',
          'Flavour': 'Flavour',
          'No': 'No',
          'msg6': 'Are Sure Want to Exit?',
          'no_data': 'No Data',
          'total': 'Total:',
          'Price': 'Price',
          'no_sold': "No's Sold",
          'no_item_found': 'No items found',
          'select_table': 'Select Table',
          'sale_rep': 'Sales report',
          'table_wise': 'TableWise report',
          'product_rep': 'Product report',
          'rms_rep': 'RMS Summary',
          'tak_awy_rep': 'TakeAway report',
          'Rate': 'Rate',
          'Qty': 'Qty',
          'Net': 'Total',
          'no_of_items': 'No of items',
          'car_rep': 'Car report',
          'Tax': 'Tax',
          'POS': 'POS',
          'Delivered': 'Delivered',
          'Print test page': 'Print test page',
          'Are you sure?': 'Are you sure?',
          'There are unsaved changes are you sure ou want to leave this page': 'There are unsaved changes are you sure ou want to leave this page',
          'Open_drawer': 'Open Drawer',
          'edit': 'Edit',
          'print': 'Print',
          'Cancel_order': 'Cancel order',
          'Clear': 'Clear',
          'pay': 'Pay',
          'reserve': 'Reserve',
          'Remove_table': 'Remove Table',
          'convert': 'Convert',
          'Barcode': 'Barcode',
          'autoFocusField': 'Auto focus field For Barcode',
          'excise_tax': 'Excise Tax',
          'total_vat': 'Total VAT ',
          'print_after_order': 'Print after order',
          'time_in_invoice': 'Time in invoice',
          'payment_method': 'Payment method',
          'show_user_kot': 'Show Username in KOT',
          'show_date_kot': 'Show Date and Time in KOT',
          'complimentary_bill': 'Complimentary Bill',
          'item_section': 'Item Section',
          'hide_tax_details': 'Show tax details',
          'Manager': 'Manager',
          'Add_Table': 'Add Table',
          'Add_a_Table': 'Add a table',
          'Table_Name': 'Table Name',
          "reserve_a_table": 'Reserve a table',
          "Date": 'Date',
          'Takeout': 'Takeout',
          'Add_Takeaway': 'Add Takeaway',
          'Add_Order': 'Add Order',
          'add_category': 'Add Category',
          "Reservations": 'Reservations',
          'Contact_Us': 'Contact Us',
          'Terms_And_Condition': 'Terms And Condition',
          'mail_us': 'Mail Us:',
          'Support': 'For Support:',
          'msg_hlp': 'Tell Us How can we help?',
          'Send': 'Send',
          'India': 'India',
          'Sales_Team': 'Sales Team',
          'Arabia': 'Arabia',
          'change': 'Change',
          'dlt_account': 'Delete Account',
          'logout': 'Logout',
          'settings': 'Settings',
          'print_settings': 'Print Settings',
          'about_us': 'About Us',
          'lng': 'Language',
          'eng': 'English',
          'gen_settings': 'General Settings',
          'general': 'General',
          'vertion_history': 'Version History',
          'power_by': 'Powered By',
          'welcome_vikn': 'Welcome to Viknbooks',
          'follow_us': 'Follow us on',
          'add_online_platform': 'Add Online Platform',
          'add_platform': 'Add Platform',
          "auto_focus": 'Auto Focus Field',
          'arabic': 'Arabic',
          'open_drawer': 'Open Drawer',
          'kot_print': 'KOT Print',
          'qty_increment': "Quantity Increment",
          'show_invoice': 'Show Invoice',
          'clear_table_after': 'Clear Table After Payment',
          'select_a_template': 'Select a Template',
          'enable_wifi': 'Enable Wifi Printer',
          'select_code_page': 'Select code page',
          'extraDetailsInKOT': 'extra Details In KOT',
          'balance1': 'Balance',
          'Deliveryman': 'Deliveryman',
          'Platform': 'Platform',
          'Full': 'Full',
          'Discount': 'Discount',
          'add': 'Add',
          'Product_Details': 'Product Details',
          'Table_Order': 'Table Order',
          'Details': 'Details',
          'Platform(Online Only)': 'Platform(Online Only)',
          'Print For Cancelled Order': 'Print For Cancelled Order',
          'direct_order_option': 'Direct order option',
          'company_alignments': "Company Details Alignments",
          'token': 'Highlighted Token No',
          'initial_token': 'Initial TokenNo',
          'dont_have_account': 'Don’t have an Account?',
          'sign_up': 'Sign up now!',
          'lang': 'English',
          'login': 'Login',
          'flavour_in_order_print': 'Flavour in order print',
          'Add_Product': "Add Product",
          'table_order_settings': "Table order settings",
          'highlightsProductDetails': 'Highlights ProductDetails',
          'KotafterPayment': 'KOT After Payment',
          'autofocus_field': 'Auto Focus field',
        },

        /////
        ///
        ///
        ///
        'ar': {
          'autofocus_field': 'مجال التركيز التلقائي',
          'KotafterPayment': 'كوت بعد الدفع',
          'flavour_in_order_print': 'نكهة من أجل الطباعة',
          'Kot afte rPayment': 'نكهة من أجل الطباعة',
           'table_order_settings': "إعدادات ترتيب الجدول",
          'reverseArabicOption': 'عكس الخيار العربي',
          'highlightsProductDetails': 'يسلط الضوء على تفاصيل المنتج',
          'Add_Product': "أضف منتج",
          'bluetoothPrinter': 'طابعة بلوتوث',
          'select_printer_type': 'حدد نوع الطابعة',
          'login': 'تسجيل الدخول',
          'lang': 'عربي',
          'sign_up': 'أفتح حساب الأن!',
          'dont_have_account': "ليس لديك حساب؟",
          'initial_token': 'الرمز الأولي ',
          'token': "الرمز المميز لا",
          'company_alignments': 'تفاصيل الشركة التوافقات',
          'Print For Cancelled Order': 'طباعة للطلب الملغى',
          'direct_order_option': 'خيار الطلب المباشر',
          'Platform(Online Only)': 'النظام الأساسي (عبر الإنترنت فقط)',
          'Details': 'تفاصيل',
          'Table_Order': 'ترتيب الجدول',
          'Product_Details': 'تفاصيل المنتج',
          'add': 'يضيف',
          'Discount': 'تخفيض',
          'Full': 'ممتلىء',
          'Platform': 'منصة',
          'Deliveryman': 'رجل التوصيل',
          'balance1': 'توازن ',
          'enable_wifi': 'تمكين طابعة واي فاي',
          'select_a_template': "اختر قالبًا",
          'clear_table_after': 'إظهار الفاتورة',
          'show_invoice': 'إظهار الفاتورة',
          'qty_increment': "زيادة الكمية",
          'kot_print': 'درج مفتوح',
          'open_drawer': 'درج مفتوح',
          'arabic': 'عربي',
          "auto_focus": 'مجال التركيز التلقائي,',
          'add_online_platform': 'إضافة منصة على الانترنت',
          'add_platform': 'إضافة منصة',
          'vertion_history': 'تاريخ النسخة',
          'power_by': 'مشغل بواسطة',
          'welcome_vikn': 'مرحبا بك فيViknbooks',
          'follow_us': 'اتبعنا',
          'change': 'يتغير',
          'dlt_account': 'حذف الحساب',
          'logout': 'تسجيل خروج',
          'settings': 'إعدادات',
          'print_settings': 'إعدادات الطباعة',
          'contact_us': 'اتصل بنا',
          'about_us': 'اتصل بنا',
          'lng': 'لغة',
          'eng': 'إنجليزي',
          'gen_settings': 'الاعدادات العامة',
          'general': 'عام',
          'Terms_And_Condition': 'أحكام وشروط',
          'mail_us': 'راسلنا بالبريد الإلكتروني',
          'Support': 'يدعم',
          'msg_hlp': 'أخبرنا كيف يمكننا المساعدة؟',
          'Send': 'يرسل',
          'India': 'الهند',
          'Sales_Team': 'فريق المبيعات',
          'Arabia': 'الجزيرة العربية',
          'Contact_Us': 'اتصل بنا',
          "Reservations": 'التحفظات',
          'add_category': 'إضافة فئة',
          'Add_Order': 'أضف طلبًا',
          'Add_Takeaway': 'أضف الوجبات الجاهزة',
          'Takeout': 'أخرج',
          "Date": 'تاريخ',
          "reserve_a_table": 'حجز طاولة',
          'Table_Name': 'اسم الطاولة',
          'Add_a_Table': 'أضف جدولاً',
          'Manager': 'مدير',
          'Add_Table': 'إضافة جدول',
          'hide_tax_details': 'شو تفاصيل الضرائب',
          'item_section': 'قسم البند',
          'complimentary_bill': 'فاتورة مجانية',
          'show_user_kot': 'إظهار اسم المستخدم في KOT',
          'show_date_kot': "إظهار التاريخ والوقت في KOT",
          'print_after_order': 'الطباعة بعد الطلب',
          'usbPrinter': 'طابعة USB',
          'payment_method': 'طريقة الدفع او السداد',
          'time_in_invoice': 'الوقت في الفاتورة',
          'autoFocusField': 'مجال التركيز التلقائي للباركود',
          'print': 'مطبعة',
          'select_branch': 'اختر فرعك',
          'edit': 'يحرر',
          'reserve': 'احتياطي',
          'Cancel_order': 'الغاء الطلب',
          'Clear': 'واضح',
          'pay': 'يدفع',
          'Remove_table': 'إزالة الجدول',
          'convert': 'يتحول',
          'Open_drawer': 'درج مفتوح',
          'Print test page': 'طباعة صفحة الاختبار',
          'Delivered': 'تم التوصيل',
          'POS': 'نقاط البيع',
          'Are you sure?': 'هل أنت متأكد؟',
          'There are unsaved changes are you sure ou want to leave this page': 'هناك تغييرات غير محفوظة، هل أنت متأكد من أنك تريد مغادرة هذه الصفحة',
          'Tax': 'ضريبة',
          'Rate': 'معدل',
          'Qty': 'كمية',
          'Net': 'المجموع',
          'no_of_items': 'عدد العناصر',
          'car_rep': 'تقرير السيارة',
          'Quick link': 'رابط سريع',
          'is_Arabic': 'عربي',
          'Verify_your_account': 'تحقق من حسابك',
          'Email': 'بريد إلكتروني',
          'enter_the_otp': 'دخول OTP',
          'resend_opt': 'إعادة إرسال OTP',
          'please_enter_email': 'الرجاء إدخال بريد إلكتروني صحيح',
          'please_enter_otp': 'تفضل otp',
          'create_vikn_acnt': 'قم بإنشاء حساب فيكن الخاص بك',
          'username': 'اسم المستخدم',
          'verification': 'سيتم استخدام هذا للتحقق.',
          'country': 'دولة',
          'phone': 'هاتف',
          'msg': 'استخدم 8 أحرف أو أكثر مع مزيج من الحروف والأرقام والرموز.',
          'sign_in_instead': 'تسجيل الدخول بدلا من ذلك.',
          'first_name': 'الاسم الأول',
          'second_name': 'الاسم الثاني',
          'Password': 'كلمة المرور',
          'confirm_password': 'تأكيد كلمة المرور',
          'choose_a_country': 'اختر بلدا',
          'sign_in_vikn_account': 'تسجيل الدخول باستخدام حساب فيكن',
          'forgot_account': 'هل نسيت كلمة السر؟',
          'or': 'أو',
          'create_an_accnt': 'إنشاء حساب',
          'please_enter_details': 'الرجاء إدخال تفاصيل المستخدم',
          'user_or_email': 'اسم المستخدم أو البريد الالكتروني',
          'go_back': 'عُد',
          'please_enter_email_username': 'الرجاء إدخال اسم المستخدم أو البريد الإلكتروني',
          'Profile': 'حساب تعريفي',
          'msg1': 'إذا قمت بحذف الحساب مرة واحدة، فلن تتمكن من استرداد معلوماتك',
          'msg2': 'يرجى قبول الشروط والأحكام',
          'dlt_acnt': 'حذف الحساب',
          'enter_pin': 'يدخل PIN',
          'call_us': 'اتصل بنا',
          'route': 'طريق',
          'tax_type': 'نوع الضريبة',
          'cam': 'آلة تصوير',
          'gall': 'صالة عرض',
          'customer': 'عميل',
          'search': 'يبحث',
          'delete_msg': 'حذف التأكيد',
          'msg4': 'هل أنت متأكد أنك تريد حذف هذا البند؟',
          'dlt': 'يمسح',
          'cancel': 'يلغي',
          'no_network': 'لا يوجد اتصال بالإنترنت',
          'retry': 'أعد المحاولة',
          'Ok': 'نعم',
          'select_date': 'حدد تاريخ',
          'Invoices': 'الفواتير',
          'from': 'من :',
          'to': 'ل :',
          'token_no': 'رقم الرمز المميز',
          'loyalty_cust': 'ولاء العملاء',
          'name': 'اسم:',
          'phone1': 'هاتف:',
          'loc': 'موقع:',
          'card_type': 'نوع البطاقة:',
          'card_no': 'لا بطاقة:',
          'Status': 'حالة',
          'msg_loylty': 'حدد عميل الولاء',
          'add_loyalty': 'أضف الولاء',
          'card_type1': 'نوع البطاقة',
          'delivery_man': 'رجل التوصيل',
          'select_customer': 'حدد العميل',
          'payment': 'قسط',
          'select_delivery_man': 'حدد رجل التسليم',
          'balance': 'توازن :',
          'to_be_paid': 'لكي تدفع',
          'total_tax': 'مجموع الضريبة',
          'net_total': 'صافي المجموع',
          'grand_total': 'المجموع الإجمالي',
          'cash': 'نقدي',
          'tot_cash': 'مجموع المبالغ النقدية:',
          'full_cash': 'كامل نقدا',
          'bank': 'بنك',
          'amt': 'كمية:',
          'pay_full': 'دفع كامل',
          'disc': 'تخفيض:',
          'print_save': 'طباعة وحفظ',
          'save': 'يحفظ',
          'choose_item': 'اختر العناصر',
          'cus_name': 'اسم الزبون',
          'ph_no': 'رقم الهاتف',
          'code': 'شفرة',
          'description': 'وصف',
          'add_item': 'اضافة عنصر',
          'veg_only': 'الخضار فقط',
          'Yes': 'نعم',
          'Dining': 'تناول الطعام',
          'choose_table': 'اختر جدولاً',
          'Refresh': 'ينعش',
          'add_table': 'إضافة جدول',
          'Reservation': 'حجز',
          'Category': 'فئة',
          'No_Cat': 'لا تصنيف',
          'no_tax': 'لا توجد فئة الضرائب',
          'msg5': 'لم يتم تحديد صورة!',
          'Product': 'منتج',
          'edit_product': 'تحرير المنتج',
          'add_product': 'منتج جديد',
          'pur_Price': 'سعر الشراء',
          'select_product': 'اختر المنتج',
          'veg': 'نباتي',
          'non_veg': 'غير نباتي',
          'Group': 'مجموعة',
          'sales_price': 'سعر المبيعات',
          'tax': 'ضريبة',
          'Inclusive': 'شامل',
          'Kitchen': 'مطبخ',
          'no_kitchen': 'No Kitchen',
          'product_group': 'مجموعة المنتجات',
          'edit_product_grp': 'تحرير مجموعة المنتجات',
          'add_product_grp': 'إضافة مجموعة المنتجات',
          'grp_name': 'أسم المجموعة:',
          'select_kitchen': 'اختر المطبخ:',
          'des': 'وصف:',
          'select_a_product_grp': 'حدد مجموعة المنتجات',
          'edit_tax': 'تحرير الضريبة',
          'add_tax': 'إضافة ضريبة',
          'tax_name': 'الاسم الضريبي:',
          'sale_percent': 'نسبة المبيعات:',
          'purchase_percent': 'نسبة الشراء:',
          'select_tax': 'اختر ضريبة',
          'choose_country': 'اختر دولة',
          'choose_state': 'اختر دولة',
          'create_org': 'إنشاء منظمة',
          'address_detail': 'تفاصيل العنوان',
          'build': 'رقم المبنى/الاسم',
          'landmark': 'معلم معروف',
          'City': 'مدينة',
          'Required': 'مطلوب',
          'postal_code': 'رمز بريدي',
          'Next': 'التالي',
          'org_profile': 'الملف التعريفي للمنظمة',
          'reg_no': 'رقم التسجيل',
          'financial_year': 'السنة المالية',
          'tax_details': 'التفاصيل الضريبية',
          'tax_no': 'الرقم الضريبي',
          'zatca': 'تمكين قاعدة ZATCA',
          'create_new_org': 'قم بإنشاء مؤسستك الجديدة',
          'create': 'يخلق',
          'select_org': 'حدد منظمة موجودة',
          'join': 'ينضم',
          'select_employee': 'اختر الموظف',
          'no_emp': 'لا موظف',
          'Report': 'تقرير',
          'report_type': 'نوع التقرير',
          'get_rep': 'احصل على التقرير',
          'cash1': 'نقدي :',
          'bank1': 'بنك :',
          'credit': 'ائتمان :',
          'grand_tot': 'المجموع الإجمالي:',
          'total_sld': 'إجمالي المبيعات:',
          'Daily_sum': 'ملخص يومي',
          'particular': 'تفاصيل',
          'CASH': 'نقدي',
          'BANK': 'بنك',
          'CREDIT': 'ائتمان',
          'opn_blns': 'الرصيد الافتتاحي',
          'sales_invoice': 'فاتورة المبيعات',
          'sales_return': 'عائد المبيعات',
          'Purchase_Invoice': 'فاتورة الشراء',
          'Purchase_Return': 'عودة شراء',
          'Expenses': 'نفقات',
          'Receipts': 'الإيصالات',
          'Barcode': 'الباركود',
          'Journals': 'المجلات',
          'closing_balance': 'الرصيد الختامي',
          'sales_summary': 'ملخص فاتورة المبيعات',
          'Gross': 'إجمالي',
          'gross_amount': 'المبلغ الإجمالي',
          'Total': 'المجموع',
          'sale_return_sum': 'ملخص إرجاع المبيعات',
          'Effective_Sale': 'البيع الفعال',
          'Effective_Sale1': '#البيع الفعال',
          'sale_invo': '#فاتورة المبيعات',
          'sale_invoice': 'فاتورة المبيعات',
          'sale_return': '#عائد المبيعات',
          'Purchase': 'شراء',
          'sale_byt_type': 'البيع حسب النوع',
          'Take_awy': 'يبعد',
          'Car': 'سيارة',
          'Order_Detailed': 'النظام مفصل',
          'order': '#طلبات',
          'amount': 'كمية',
          'Cancelled': 'ألغيت',
          'Pending': 'قيد الانتظار',
          'ord_emp': 'الطلب حسب الموظف',
          'Employee': 'موظف',
          '#Cancelled': '#ألغيت',
          'sales_emp': 'المبيعات حسب الموظف',
          'Sales': 'مبيعات',
          '#Return': '#يعود',
          'report_preview': 'معاينة التقرير',
          'Waiter': 'النادل',
          'No_waiter': 'لا يوجد نادل',
          'select_printer': 'حدد الطابعة',
          'select_capability': 'حدد القدرات',
          'select_role': 'حدد الدور',
          'Settings': 'إعدادات',
          'KOT_log': 'سجل KOT',
          'user_role': 'أدوار المستخدمين',
          'role_name': 'اسم الدور',
          'Role': 'دور',
          'Online': 'متصل',
          'wifi_printer': 'طابعة واي فاي',
          'select_temp': 'حدد قالب:',
          'sale_order': 'طلب المبيعات',
          'set_def': 'الوضع الإفتراضي',
          'highlight_tkn_no': 'رقم الرمز المميز',
          'payment_detail': 'بيانات الدفع',
          'com_detail_align': 'محاذاة تفاصيل الشركة',
          'gen_setting': 'الاعدادات العامة',
          'printer_set': 'إعدادات الطابعة',
          'add_print': 'إضافة طابعة',
          'kit_set': 'إعدادات المطبخ',
          'privacy_policy': 'سياسة الخصوصية',
          'terms_condition': 'الأحكام والشروط',
          'vertion_detail': 'تفاصيل الإصدار',
          'log_out': 'تسجيل خروج',
          'KOT_print': 'KOT مطبعة',
          'qty_inc': 'زيادة الكمية',
          'show_inv': 'إظهار الفاتورة',
          'clear_table': 'مسح الجدول بعد الدفع',
          'print_after_payment': 'الطباعة بعد الدفع',
          'intial_tkn': 'رقم الرمز الأولي',
          'com_hr': 'ساعة التعويض',
          'Printers': 'الطابعات',
          'print_name': 'اسم الطابعات',
          'kit_name': 'اسم المطبخ',
          'kit_print': 'طباعة المطبخ',
          'set_both': 'ضع كلاهما',
          'select_print': 'حدد الطابعة:',
          'Users': 'المستخدمين',
          'Generate': 'يولد',
          'New': 'جديد',
          'Add': 'يضيف',
          'kot_a_print': 'كوت طباعة',
          'custom_print': 'تخصيص الطباعة',
          'reset_time': 'وقت إعادة تعيين الرمز المميز',
          'waiter_pay': 'يمكن للنادل الدفع',
          'Dashboard': 'لوحة القيادة',
          'com_info': 'معلومات الشركة',
          'user_log_out': 'تسجيل خروج المستخدم',
          'Products': 'منتجات',
          'Flavour': 'نكهة',
          'No': 'لا',
          'msg6': 'هل تريد بالتأكيد الخروج؟',
          'no_data': 'لايوجد بيانات',
          'total': 'المجموع:',
          'Price': 'سعر',
          'no_sold': 'تم بيع الرقم',
          'no_item_found': 'لم يتم العثور على العناصر',
          'select_table': 'حدد الجدول',
          'sale_rep': 'تقرير المبيعات',
          'table_wise': 'تقرير الجدول الحكيم',
          'product_rep': 'تقرير المنتج',
          'rms_rep': 'RMS ملخص',
          'tak_awy_rep': 'تقرير الوجبات الجاهزة',
          'excise_tax': 'الضريبة',
          'total_vat': 'ضريبة القيمة المضافة',
          'select_code_page': 'حدد صفحة الرموز',
          'extraDetailsInKOT': 'تفاصيل إضافية في KOT'
        },
      };
}
