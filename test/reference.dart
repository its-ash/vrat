/// Reference dates for New Delhi from Drik Panchang (drikpanchang.com), read
/// in November 2026: the Ekadashi, Pradosh, Purnima, Amavasya, Sankashti
/// Chaturthi, Vinayaka Chaturthi, Masik Shivaratri, Masik Durgashtami and
/// Hindu calendar pages for 2026 and 2027, plus the Diwali calendar page.
/// Pages: /vrats/ekadashidates.html, /vrats/pradoshdates.html,
/// /vrats/purnimasidates.html, /vrats/amavasyadates.html,
/// /vrats/sankashti-chaturthi-dates.html, /vrats/vinayaka-chaturthi-dates.html,
/// /vrats/masik-shivaratri-dates.html, /vrats/masik-durgashtami-dates.html,
/// /calendars/hindu/hinducalendar.html, /diwali/diwali-puja-calendar.html,
/// each with `?geoname-id=1261481&year=YYYY`.
///
/// Dates are `MM-DD` within the year. Ekadashi lists the Smarta date.
library;

const ekadashi2026 = {
  '01-14': 'shattila', '01-29': 'jaya', '02-13': 'vijaya', '02-27': 'amalaki', '03-15': 'papmochani',
  '03-29': 'kamada', '04-13': 'varuthini', '04-27': 'mohini', '05-13': 'apara', '05-27': 'padmini',
  '06-11': 'parama', '06-25': 'nirjala', '07-10': 'yogini', '07-25': 'devshayani', '08-09': 'kamika',
  '08-23': 'shravana_putrada', '09-07': 'aja', '09-22': 'parsva', '10-06': 'indira', '10-22': 'papankusha',
  '11-05': 'rama', '11-20': 'devutthana', '12-04': 'utpanna', '12-20': 'mokshada',
};

const ekadashi2027 = {
  '01-03': 'saphala', '01-18': 'pausha_putrada', '02-02': 'shattila', '02-17': 'jaya', '03-04': 'vijaya',
  '03-18': 'amalaki', '04-02': 'papmochani', '04-17': 'kamada', '05-02': 'varuthini', '05-16': 'mohini',
  '06-01': 'apara', '06-14': 'nirjala', '06-30': 'yogini', '07-14': 'devshayani', '07-29': 'kamika',
  '08-12': 'shravana_putrada', '08-28': 'aja', '09-11': 'parsva', '09-26': 'indira', '10-11': 'papankusha',
  '10-25': 'rama', '11-10': 'devutthana', '11-24': 'utpanna', '12-09': 'mokshada', '12-23': 'saphala',
};

const pradosh2026 = [
  '01-01', '01-16', '01-30', '02-14', '03-01', '03-16', '03-30', '04-15', '04-28', '05-14', '05-28',
  '06-12', '06-27', '07-12', '07-26', '08-10', '08-25', '09-08', '09-24', '10-08', '10-23', '11-06',
  '11-22', '12-06', '12-21',
];

const pradosh2027 = [
  '01-05', '01-20', '02-03', '02-18', '03-05', '03-20', '04-04', '04-18', '05-03', '05-17', '06-02',
  '06-16', '07-01', '07-15', '07-31', '08-14', '08-29', '09-13', '09-27', '10-12', '10-27', '11-11',
  '11-25', '12-11', '12-25',
];

/// Purnima vrat day (the first date where Drik lists two).
const purnima2026 = [
  '01-03', '02-01', '03-03', '04-01', '05-01', '05-30', '06-29', '07-29', '08-27', '09-26', '10-25',
  '11-24', '12-23',
];
const purnima2027 = [
  '01-22', '02-20', '03-22', '04-20', '05-20', '06-18', '07-18', '08-16', '09-15', '10-15', '11-13',
  '12-13',
];

/// Amavasya (the first date where Drik lists two: the day with Amavasya in the afternoon).
const amavasya2026 = [
  '01-18', '02-17', '03-18', '04-17', '05-16', '06-14', '07-14', '08-12', '09-10', '10-10', '11-08',
  '12-08',
];
const amavasya2027 = [
  '01-07', '02-06', '03-07', '04-06', '05-06', '06-04', '07-03', '08-02', '08-31', '09-29', '10-29',
  '11-27', '12-27',
];

/// Sankashti Chaturthi with Drik's moonrise (24 h, local).
const sankashti2026 = {
  '01-06': '20:59', '02-05': '21:39', '03-06': '21:18', '04-05': '21:58', '05-05': '22:35',
  '06-03': '22:04', '07-03': '21:53', '08-02': '21:24', '08-31': '20:29', '09-29': '19:44',
  '10-29': '20:17', '11-27': '20:18', '12-26': '20:19',
};
const sankashti2027 = {
  '01-25': '21:16', '02-24': '22:03', '03-25': '21:49', '04-24': '22:32', '05-23': '22:03',
  '06-22': '21:57', '07-22': '21:27', '08-20': '20:27', '09-19': '20:08', '10-18': '19:35',
  '11-17': '20:26', '12-16': '20:30',
};

const vinayaka2026 = [
  '01-22', '02-21', '03-22', '04-20', '05-20', '06-18', '07-17', '08-16', '09-14', '10-14', '11-13',
  '12-13',
];
const vinayaka2027 = [
  '01-11', '02-10', '03-12', '04-10', '05-09', '06-08', '07-07', '08-05', '09-04', '10-03', '11-02',
  '12-02', '12-31',
];

const masikShivratri2026 = [
  '01-16', '02-15', '03-17', '04-15', '05-15', '06-13', '07-12', '08-11', '09-09', '10-08', '11-07',
  '12-07',
];
const masikShivratri2027 = [
  '01-05', '02-04', '03-06', '04-05', '05-04', '06-03', '07-02', '07-31', '08-30', '09-28', '10-27',
  '11-26', '12-25',
];

const masikDurgashtami2026 = [
  '01-26', '02-24', '03-26', '04-24', '05-23', '06-22', '07-21', '08-20', '09-19', '10-19', '11-17',
  '12-17',
];
const masikDurgashtami2027 = [
  '01-16', '02-14', '03-16', '04-14', '05-13', '06-11', '07-11', '08-09', '09-08', '10-07', '11-06',
  '12-06',
];

/// Festival id -> {2026 date, 2027 date}.
const festivals = <String, (String, String)>{
  'makar_sankranti': ('01-14', '01-15'),
  'vasant_panchami': ('01-23', '02-11'),
  'maha_shivratri': ('02-15', '03-06'),
  'holika_dahan': ('03-03', '03-21'),
  'holi': ('03-04', '03-22'),
  'chaitra_navratri': ('03-19', '04-07'),
  'ram_navami': ('03-26', '04-15'), // Smarta 2026; ISKCON 03-27
  'hanuman_jayanti': ('04-02', '04-20'),
  'akshaya_tritiya': ('04-19', '05-09'),
  'guru_purnima': ('07-29', '07-18'),
  'raksha_bandhan': ('08-28', '08-17'),
  'janmashtami': ('09-04', '08-25'),
  'ganesh_chaturthi': ('09-14', '09-04'),
  'sharad_navratri': ('10-11', '09-30'),
  'durga_ashtami': ('10-19', '10-07'),
  'dussehra': ('10-20', '10-09'),
  'karwa_chauth': ('10-29', '10-18'),
  'dhanteras': ('11-06', '10-27'),
  'diwali': ('11-08', '10-29'),
  'govardhan_puja': ('11-10', '10-30'),
  'bhai_dooj': ('11-11', '10-31'),
  'chhath': ('11-15', '11-04'),
};
