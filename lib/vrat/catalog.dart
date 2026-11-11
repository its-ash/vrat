import '../data/names.dart';
import 'observance.dart';

/// Names and descriptions of the observances, in English and Hindi.
class Info {
  const Info(this.name, this.about, this.observe, {this.rule});

  final Bi name;

  /// What the day is and its significance.
  final Bi about;

  /// How it is observed.
  final Bi observe;

  /// How the app decides the day, and where traditions differ.
  final Bi? rule;
}

const _ekadashiAbout = Bi(
  'Ekadashi is the eleventh tithi of each fortnight and is dedicated to Lord Vishnu. It comes twice a month, '
  'about 24 times a year, and each one has its own name and story.',
  'एकादशी प्रत्येक पक्ष की ग्यारहवीं तिथि है और भगवान विष्णु को समर्पित है। यह महीने में दो बार, '
  'यानी वर्ष में लगभग 24 बार आती है, और हर एकादशी का अपना नाम और कथा है।',
);

const _ekadashiObserve = Bi(
  'Devotees fast, many taking only fruit, milk or water and avoiding grains and pulses. They worship Vishnu, '
  'read the Ekadashi katha and keep a vigil. The fast is broken on Dwadashi morning during the parana time, '
  'after sunrise and after Hari Vasara (the first quarter of Dwadashi) has passed.',
  'भक्त व्रत रखते हैं; अनेक लोग केवल फल, दूध या जल लेते हैं और अन्न व दालों से दूर रहते हैं। विष्णु जी की पूजा, '
  'एकादशी कथा और रात्रि जागरण किया जाता है। व्रत द्वादशी की सुबह पारण के समय में खोला जाता है, '
  'जो सूर्योदय और हरि वासर (द्वादशी का पहला चौथाई भाग) बीतने के बाद आरंभ होता है।',
);

const _ekadashiRule = Bi(
  'The day on which Ekadashi is present at sunrise (the Smarta date). If it is present at two sunrises, the first day '
  'is kept unless Dashami is still running within about 2 h 24 min before that sunrise; then the second day. If it '
  'covers a sunrise for less than 48 minutes, the day it began is kept. If it is present at no sunrise, the day on '
  'which it covers most of the daylight. Vaishnava and ISKCON followers often fast one day later; check when Ekadashi '
  'ends below and follow your own tradition.',
  'वह दिन जब सूर्योदय के समय एकादशी हो (स्मार्त तिथि)। यदि एकादशी दो सूर्योदयों पर हो, तो पहला दिन लिया जाता है, '
  'पर उस सूर्योदय से लगभग 2 घंटे 24 मिनट पहले तक दशमी चल रही हो तो दूसरा दिन। यदि वह किसी सूर्योदय को 48 मिनट से कम '
  'छूती हो, तो वह दिन जिसमें वह आरंभ हुई। यदि किसी भी सूर्योदय पर एकादशी न हो, तो वह दिन जिसमें एकादशी दिन के '
  'अधिकांश भाग में रहे। वैष्णव और इस्कॉन परंपरा में व्रत प्रायः एक दिन बाद होता है; नीचे एकादशी की समाप्ति का समय देखकर '
  'अपनी परंपरा के अनुसार चलें।',
);

/// Ekadashi by name: (name, one-line note).
const ekadashiNames = <String, (Bi, Bi)>{
  'kamada': (
    Bi('Kamada Ekadashi', 'कामदा एकादशी'),
    Bi('Chaitra Shukla. Said to fulfil wishes and free one from sin.', 'चैत्र शुक्ल। मान्यता है कि यह कामनाएँ पूर्ण करती और पापों से मुक्त करती है।'),
  ),
  'papmochani': (
    Bi('Papmochani Ekadashi', 'पापमोचिनी एकादशी'),
    Bi('Chaitra Krishna (Phalguna Krishna in the amanta count). The Ekadashi that removes sins.', 'चैत्र कृष्ण (अमांत गणना में फाल्गुन कृष्ण)। पापों का नाश करने वाली एकादशी।'),
  ),
  'varuthini': (
    Bi('Varuthini Ekadashi', 'वरूथिनी एकादशी'),
    Bi('Vaishakha Krishna. Varuthini means protective; it is kept for protection and merit.', 'वैशाख कृष्ण। वरूथिनी का अर्थ है रक्षा करने वाली; यह सुरक्षा और पुण्य के लिए रखी जाती है।'),
  ),
  'mohini': (
    Bi('Mohini Ekadashi', 'मोहिनी एकादशी'),
    Bi('Vaishakha Shukla. Linked with Vishnu\'s Mohini form.', 'वैशाख शुक्ल। भगवान विष्णु के मोहिनी रूप से जुड़ी है।'),
  ),
  'apara': (
    Bi('Apara (Achala) Ekadashi', 'अपरा (अचला) एकादशी'),
    Bi('Jyeshtha Krishna. Said to remove great sins and bring abundant merit.', 'ज्येष्ठ कृष्ण। मान्यता है कि यह बड़े पापों को दूर करती और अपार पुण्य देती है।'),
  ),
  'nirjala': (
    Bi('Nirjala Ekadashi', 'निर्जला एकादशी'),
    Bi('Jyeshtha Shukla, also called Bhimseni Ekadashi. The strictest Ekadashi, kept without food and water; it is said to equal all 24 Ekadashis.', 'ज्येष्ठ शुक्ल, इसे भीमसेनी एकादशी भी कहते हैं। सबसे कठोर एकादशी, जिसमें अन्न-जल दोनों का त्याग होता है; मान्यता है कि इसका फल सभी 24 एकादशियों के बराबर है।'),
  ),
  'yogini': (
    Bi('Yogini Ekadashi', 'योगिनी एकादशी'),
    Bi('Ashadha Krishna. Said to heal ailments and free one from sin.', 'आषाढ़ कृष्ण। मान्यता है कि यह रोगों और पापों से मुक्ति देती है।'),
  ),
  'devshayani': (
    Bi('Devshayani Ekadashi', 'देवशयनी एकादशी'),
    Bi('Ashadha Shukla, also Ashadhi or Padma Ekadashi. Vishnu is said to begin his four-month rest (Chaturmas) today.', 'आषाढ़ शुक्ल, इसे आषाढ़ी या पद्मा एकादशी भी कहते हैं। मान्यता है कि आज से भगवान विष्णु चार माह (चातुर्मास) की योगनिद्रा में जाते हैं।'),
  ),
  'kamika': (
    Bi('Kamika Ekadashi', 'कामिका एकादशी'),
    Bi('Shravana Krishna. Worship of Vishnu with tulsi leaves is especially favoured.', 'श्रावण कृष्ण। इस दिन तुलसी दल से विष्णु पूजन का विशेष महत्व है।'),
  ),
  'shravana_putrada': (
    Bi('Shravana Putrada Ekadashi', 'श्रावण पुत्रदा एकादशी'),
    Bi('Shravana Shukla. Kept for children and the welfare of the family.', 'श्रावण शुक्ल। संतान और परिवार के कल्याण के लिए रखी जाती है।'),
  ),
  'aja': (
    Bi('Aja Ekadashi', 'अजा एकादशी'),
    Bi('Bhadrapada Krishna. Said to remove sorrow; linked with the story of King Harishchandra.', 'भाद्रपद कृष्ण। दुख दूर करने वाली मानी जाती है; राजा हरिश्चंद्र की कथा से जुड़ी है।'),
  ),
  'parsva': (
    Bi('Parsva (Parivartini) Ekadashi', 'पार्श्व (परिवर्तिनी) एकादशी'),
    Bi('Bhadrapada Shukla, also Vamana Ekadashi. Vishnu is said to turn on his side in his sleep today.', 'भाद्रपद शुक्ल, इसे वामन एकादशी भी कहते हैं। मान्यता है कि आज विष्णु शयन में करवट बदलते हैं।'),
  ),
  'indira': (
    Bi('Indira Ekadashi', 'इंदिरा एकादशी'),
    Bi('Ashwin Krishna, in Pitru Paksha. Kept for the peace of ancestors.', 'आश्विन कृष्ण, पितृ पक्ष में। पितरों की शांति के लिए रखी जाती है।'),
  ),
  'papankusha': (
    Bi('Papankusha Ekadashi', 'पापांकुशा एकादशी'),
    Bi('Ashwin Shukla, after Dussehra. Said to check sins as a goad checks an elephant.', 'आश्विन शुक्ल, दशहरा के बाद। मान्यता है कि यह पापों पर अंकुश लगाती है।'),
  ),
  'rama': (
    Bi('Rama Ekadashi', 'रमा एकादशी'),
    Bi('Kartika Krishna (Ashwin Krishna in the amanta count). Named after Goddess Lakshmi (Rama); it falls just before Diwali.', 'कार्तिक कृष्ण (अमांत गणना में आश्विन कृष्ण)। देवी लक्ष्मी (रमा) के नाम पर; दीपावली से ठीक पहले आती है।'),
  ),
  'devutthana': (
    Bi('Dev Uthani (Prabodhini) Ekadashi', 'देवउठनी (प्रबोधिनी) एकादशी'),
    Bi('Kartika Shukla. Vishnu awakens after Chaturmas; Tulsi Vivah is held and the wedding season begins.', 'कार्तिक शुक्ल। चातुर्मास के बाद विष्णु जागते हैं; तुलसी विवाह होता है और विवाह के मुहूर्त आरंभ होते हैं।'),
  ),
  'utpanna': (
    Bi('Utpanna Ekadashi', 'उत्पन्ना एकादशी'),
    Bi('Margashirsha Krishna. The day Goddess Ekadashi is said to have appeared; a good day to begin the Ekadashi vow.', 'मार्गशीर्ष कृष्ण। मान्यता है कि इस दिन देवी एकादशी प्रकट हुईं; एकादशी व्रत आरंभ करने के लिए उत्तम दिन।'),
  ),
  'mokshada': (
    Bi('Mokshada Ekadashi', 'मोक्षदा एकादशी'),
    Bi('Margashirsha Shukla, also Vaikuntha Ekadashi. Said to grant liberation; Gita Jayanti is kept on this day.', 'मार्गशीर्ष शुक्ल, इसे वैकुंठ एकादशी भी कहते हैं। मोक्ष देने वाली मानी जाती है; इसी दिन गीता जयंती मनाई जाती है।'),
  ),
  'saphala': (
    Bi('Saphala Ekadashi', 'सफला एकादशी'),
    Bi('Pausha Krishna. Kept for success in one\'s undertakings.', 'पौष कृष्ण। कार्यों में सफलता के लिए रखी जाती है।'),
  ),
  'pausha_putrada': (
    Bi('Pausha Putrada Ekadashi', 'पौष पुत्रदा एकादशी'),
    Bi('Pausha Shukla. Kept for children; also Vaikuntha Ekadashi in South India.', 'पौष शुक्ल। संतान की कामना से रखी जाती है; दक्षिण भारत में इसे वैकुंठ एकादशी भी कहते हैं।'),
  ),
  'shattila': (
    Bi('Shattila Ekadashi', 'षटतिला एकादशी'),
    Bi('Magha Krishna (Pausha Krishna in the amanta count). Named for sesame (til), which is used in six ways: bathing, paste, offering, charity, food and drink.', 'माघ कृष्ण (अमांत गणना में पौष कृष्ण)। तिल के छह प्रकार के प्रयोग (स्नान, उबटन, हवन, दान, भोजन, तर्पण) के कारण यह नाम पड़ा।'),
  ),
  'jaya': (
    Bi('Jaya Ekadashi', 'जया एकादशी'),
    Bi('Magha Shukla. Said to free one from negative states and bring victory.', 'माघ शुक्ल। मान्यता है कि यह नकारात्मक अवस्थाओं से मुक्ति और विजय देती है।'),
  ),
  'vijaya': (
    Bi('Vijaya Ekadashi', 'विजया एकादशी'),
    Bi('Phalguna Krishna (Magha Krishna in the amanta count). Brings victory; linked with Rama\'s journey to Lanka.', 'फाल्गुन कृष्ण (अमांत गणना में माघ कृष्ण)। विजय देने वाली; श्रीराम की लंका यात्रा की कथा से जुड़ी है।'),
  ),
  'amalaki': (
    Bi('Amalaki Ekadashi', 'आमलकी एकादशी'),
    Bi('Phalguna Shukla. The amla tree is worshipped, as Vishnu is said to dwell in it.', 'फाल्गुन शुक्ल। इस दिन आँवले के वृक्ष की पूजा होती है।'),
  ),
  'padmini': (
    Bi('Padmini Ekadashi', 'पद्मिनी एकादशी'),
    Bi('Shukla Ekadashi of an adhika (extra) month, which comes about once in three years.', 'अधिक मास की शुक्ल एकादशी, जो लगभग तीन वर्ष में एक बार आती है।'),
  ),
  'parama': (
    Bi('Parama Ekadashi', 'परमा एकादशी'),
    Bi('Krishna Ekadashi of an adhika (extra) month, which comes about once in three years.', 'अधिक मास की कृष्ण एकादशी, जो लगभग तीन वर्ष में एक बार आती है।'),
  ),
};

const _rulePradosh = Bi(
  'The day on which Trayodashi covers the pradosh time, 2 hours 24 minutes after sunset.',
  'वह दिन जब सूर्यास्त के बाद 2 घंटे 24 मिनट के प्रदोष काल में त्रयोदशी हो।',
);

/// The catalog. Keys are [Observance.id].
const catalog = <String, Info>{
  'ekadashi': Info(Bi('Ekadashi', 'एकादशी'), _ekadashiAbout, _ekadashiObserve, rule: _ekadashiRule),
  'pradosh': Info(
    Bi('Pradosh Vrat', 'प्रदोष व्रत'),
    Bi('Pradosh is the twilight after sunset on Trayodashi, sacred to Lord Shiva. It comes twice a month. Pradosh on a Monday (Soma) or Saturday (Shani) is considered especially auspicious.',
        'प्रदोष त्रयोदशी की संध्या का वह समय है जो भगवान शिव को समर्पित है। यह महीने में दो बार आता है। सोमवार (सोम प्रदोष) और शनिवार (शनि प्रदोष) का प्रदोष विशेष शुभ माना जाता है।'),
    Bi('Fast through the day, bathe before sunset and worship Shiva in the pradosh time: abhishek with water or milk, bilva leaves, and Shiva stotras. The fast is broken after the evening puja.',
        'दिन भर उपवास रखें, सूर्यास्त से पहले स्नान करें और प्रदोष काल में शिव जी की पूजा करें: जल या दूध से अभिषेक, बिल्वपत्र और शिव स्तोत्र। संध्या पूजन के बाद व्रत खोला जाता है।'),
    rule: _rulePradosh,
  ),
  'purnima': Info(
    Bi('Purnima', 'पूर्णिमा'),
    Bi('The full moon day, the last tithi of the bright fortnight. It is a day for Satyanarayan puja, holy bathing and charity, and many people fast.',
        'पूर्णिमा शुक्ल पक्ष की अंतिम तिथि और पूर्ण चंद्रमा का दिन है। इस दिन सत्यनारायण पूजा, पवित्र स्नान और दान किया जाता है और अनेक लोग व्रत रखते हैं।'),
    Bi('Bathe early (in a river if you can), fast, worship Vishnu or Satyanarayan, give to the needy, and offer water to the Moon at moonrise.',
        'सुबह स्नान करें (संभव हो तो नदी में), व्रत रखें, विष्णु या सत्यनारायण की पूजा करें, ज़रूरतमंदों को दान दें और चंद्रोदय पर चंद्रमा को अर्घ्य दें।'),
    rule: Bi('The day on which Purnima covers the afternoon (aparahna), which is the vrat day in printed almanacs. It can differ from the day Purnima is present at sunrise.',
        'वह दिन जब पूर्णिमा अपराह्न में हो; पंचांगों में व्रत का दिन यही होता है। यह उस दिन से अलग हो सकता है जब सूर्योदय के समय पूर्णिमा हो।'),
  ),
  'amavasya': Info(
    Bi('Amavasya', 'अमावस्या'),
    Bi('The new moon day, the last tithi of the dark fortnight. It is kept for remembering ancestors (tarpan and shraddha), charity and holy bathing.',
        'अमावस्या कृष्ण पक्ष की अंतिम तिथि और नए चंद्रमा का दिन है। यह पितरों के स्मरण (तर्पण और श्राद्ध), दान और पवित्र स्नान के लिए मानी जाती है।'),
    Bi('Bathe, offer water and sesame to ancestors, feed Brahmins or the needy, light a lamp in the evening. Amavasya on Monday (Somvati) and Saturday are especially observed.',
        'स्नान करें, पितरों को जल और तिल अर्पित करें, ब्राह्मणों या ज़रूरतमंदों को भोजन कराएँ और संध्या को दीपक जलाएँ। सोमवती और शनिश्चरी अमावस्या विशेष रूप से मानी जाती हैं।'),
    rule: Bi('The day on which Amavasya covers the afternoon (aparahna), the time for shraddha. If Amavasya also touches the next sunrise, that day is a second Amavasya snan day.',
        'वह दिन जब अमावस्या अपराह्न में हो, जो श्राद्ध का समय है। यदि अमावस्या अगले सूर्योदय को भी छूती है, तो वह दिन भी स्नान-दान की अमावस्या होती है।'),
  ),
  'sankashti': Info(
    Bi('Sankashti Chaturthi', 'संकष्टी चतुर्थी'),
    Bi('Krishna Paksha Chaturthi, dedicated to Lord Ganesha, who removes obstacles (sankashta). It comes once a month.',
        'कृष्ण पक्ष की चतुर्थी, जो विघ्नहर्ता भगवान गणेश को समर्पित है। यह महीने में एक बार आती है।'),
    Bi('Fast through the day and worship Ganesha with durva grass and modak. The fast is broken in the evening after seeing the Moon at moonrise and offering it water. The moonrise time is shown for your city.',
        'दिन भर उपवास रखें और दूर्वा व मोदक से गणेश जी की पूजा करें। संध्या को चंद्रोदय पर चंद्र दर्शन कर उसे अर्घ्य देने के बाद व्रत खोला जाता है। आपके शहर के लिए चंद्रोदय का समय दिया गया है।'),
    rule: Bi('The day on which the Moon rises in Chaturthi. If Chaturthi is not present at moonrise on any day, the day it covers most of the daylight.',
        'वह दिन जब चंद्रोदय के समय चतुर्थी हो। यदि किसी दिन चंद्रोदय पर चतुर्थी न हो, तो वह दिन जिसमें वह दिन के अधिकांश भाग में रहे।'),
  ),
  'vinayaka': Info(
    Bi('Vinayaka Chaturthi', 'विनायक चतुर्थी'),
    Bi('Shukla Paksha Chaturthi, also called Vinayaka or Varad Chaturthi, dedicated to Lord Ganesha. It comes once a month.',
        'शुक्ल पक्ष की चतुर्थी, जिसे विनायक या वरद चतुर्थी भी कहते हैं, भगवान गणेश को समर्पित है। यह महीने में एक बार आती है।'),
    Bi('Fast, and worship Ganesha at midday (madhyahna) with durva, red flowers and modak. According to tradition, avoid looking at the Moon this evening.',
        'व्रत रखें और मध्याह्न में दूर्वा, लाल फूल और मोदक से गणेश पूजन करें। परंपरा के अनुसार इस शाम चंद्रमा को न देखें।'),
    rule: Bi('The day on which Chaturthi covers madhyahna, the middle of the day.', 'वह दिन जब चतुर्थी मध्याह्न (दिन के मध्य) में हो।'),
  ),
  'masik_shivratri': Info(
    Bi('Masik Shivratri', 'मासिक शिवरात्रि'),
    Bi('The monthly night of Shiva, on Krishna Paksha Chaturdashi. The great Shivratri in Magha (Maha Shivratri) is the most important of them.',
        'कृष्ण पक्ष की चतुर्दशी को आने वाली शिव की मासिक रात्रि। माघ की महाशिवरात्रि इनमें सबसे प्रमुख है।'),
    Bi('Fast, bathe the Shivalinga with water, milk and bilva leaves, chant Om Namah Shivaya and keep a vigil at night. The best time for puja is nishita, around midnight.',
        'उपवास रखें, शिवलिंग का जल, दूध और बिल्वपत्र से अभिषेक करें, ॐ नमः शिवाय का जाप करें और रात्रि जागरण करें। पूजा का श्रेष्ठ समय निशीथ काल, यानी लगभग मध्यरात्रि है।'),
    rule: Bi('The day (evening) on which Chaturdashi covers nishita, the midnight muhurta.', 'वह दिन (संध्या) जब निशीथ काल, यानी मध्यरात्रि मुहूर्त में चतुर्दशी हो।'),
  ),
  'masik_durgashtami': Info(
    Bi('Masik Durgashtami', 'मासिक दुर्गाष्टमी'),
    Bi('Shukla Paksha Ashtami, kept every month for Goddess Durga. The Ashtami of Ashwin (Navratri) is the greatest.',
        'हर महीने शुक्ल पक्ष की अष्टमी को देवी दुर्गा के लिए रखी जाती है। आश्विन (नवरात्रि) की अष्टमी सबसे महत्वपूर्ण है।'),
    Bi('Fast, worship Durga with red flowers and chant Durga Saptashati or the Durga Chalisa.',
        'व्रत रखें, लाल फूलों से दुर्गा जी की पूजा करें और दुर्गा सप्तशती या दुर्गा चालीसा का पाठ करें।'),
    rule: Bi('The day on which Ashtami is present at sunrise.', 'वह दिन जब सूर्योदय के समय अष्टमी हो।'),
  ),
  'makar_sankranti': Info(
    Bi('Makar Sankranti', 'मकर संक्रांति'),
    Bi('Marks the Sun\'s entry into Makara (Capricorn) and the start of Uttarayana, the Sun\'s northward journey. It is celebrated as Pongal, Magh Bihu, Uttarayan and Khichdi, and Lohri is on the eve.',
        'सूर्य के मकर राशि में प्रवेश और उत्तरायण (सूर्य की उत्तर की ओर यात्रा) के आरंभ का पर्व। इसे पोंगल, माघ बिहू, उत्तरायण और खिचड़ी के रूप में मनाया जाता है; लोहड़ी इसकी पूर्व संध्या पर होती है।'),
    Bi('Holy bath at dawn, charity of sesame, jaggery and khichdi, sweets of sesame and jaggery, and kite flying in Gujarat and Rajasthan.',
        'प्रातः पवित्र स्नान, तिल, गुड़ और खिचड़ी का दान, तिल-गुड़ के पकवान, और गुजरात-राजस्थान में पतंगबाज़ी।'),
    rule: Bi('The day of the Sun\'s entry into sidereal Makara; if that happens after sunset, the next day.',
        'सूर्य के निरयण मकर में प्रवेश का दिन; यदि प्रवेश सूर्यास्त के बाद हो, तो अगला दिन।'),
  ),
  'vasant_panchami': Info(
    Bi('Vasant Panchami', 'वसंत पंचमी'),
    Bi('Magha Shukla Panchami, the arrival of spring, dedicated to Goddess Saraswati, giver of knowledge and the arts.',
        'माघ शुक्ल पंचमी, वसंत ऋतु के आगमन का पर्व, जो विद्या और कला की देवी सरस्वती को समर्पित है।'),
    Bi('Wear yellow, worship Saraswati and place books and instruments before her. Children are often begun on their first letters today.',
        'पीले वस्त्र पहनें, सरस्वती जी की पूजा करें और उनके सामने पुस्तकें व वाद्य रखें। बच्चों का अक्षर-आरंभ भी प्रायः इसी दिन कराया जाता है।'),
    rule: Bi('The day on which Panchami covers the first part of the day (purvahna).', 'वह दिन जब दिन के पहले भाग (पूर्वाह्न) में पंचमी हो।'),
  ),
  'maha_shivratri': Info(
    Bi('Maha Shivratri', 'महाशिवरात्रि'),
    Bi('The Great Night of Shiva, on Magha Krishna Chaturdashi (called Phalguna Krishna Chaturdashi in the North). It honours Shiva\'s union with Parvati and his cosmic dance.',
        'शिव की महारात्रि, माघ कृष्ण चतुर्दशी को (उत्तर भारत में इसे फाल्गुन कृष्ण चतुर्दशी कहा जाता है)। यह शिव-पार्वती के विवाह और शिव के तांडव का स्मरण है।'),
    Bi('Fast all day, keep a night-long vigil with puja in the four praharas, bathe the Shivalinga with milk, water and bilva leaves and chant Om Namah Shivaya.',
        'दिन भर उपवास रखें, रात भर जागरण करें और चारों प्रहर पूजा करें, शिवलिंग का दूध, जल और बिल्वपत्र से अभिषेक करें और ॐ नमः शिवाय का जाप करें।'),
    rule: Bi('The day (evening) on which Chaturdashi covers nishita, the midnight muhurta.', 'वह दिन (संध्या) जब निशीथ काल, यानी मध्यरात्रि में चतुर्दशी हो।'),
  ),
  'holika_dahan': Info(
    Bi('Holika Dahan', 'होलिका दहन'),
    Bi('The bonfire on the evening of Phalguna Purnima, recalling the victory of Prahlada\'s devotion over evil as embodied by Holika.',
        'फाल्गुन पूर्णिमा की संध्या का अलाव, जो प्रह्लाद की भक्ति की बुराई (होलिका) पर विजय का स्मरण कराता है।'),
    Bi('Light the Holika in the evening, walk around it, and offer coconut, grain and sweets. Bhadra (Vishti karana) is avoided.',
        'संध्या को होलिका जलाएँ, उसकी परिक्रमा करें और नारियल, अनाज व मिठाई अर्पित करें। भद्रा (विष्टि करण) में दहन नहीं किया जाता।'),
    rule: Bi('The day on which Purnima covers pradosh, without Bhadra. If Bhadra covers all of that evening, the next day is shown while Purnima still reaches into its evening; if Purnima ended much earlier (more than about 96 minutes before sunset), the first day is kept, with the dahan in the tail of Bhadra. Some almanacs differ by one day.',
        'वह दिन जब प्रदोष में भद्रा-रहित पूर्णिमा हो। यदि पूरी संध्या भद्रा में हो, तो अगला दिन दिखाया जाता है जब तक पूर्णिमा उसकी संध्या तक पहुँचती हो; यदि पूर्णिमा सूर्यास्त से लगभग 96 मिनट से अधिक पहले समाप्त हो जाए, तो पहला दिन रखा जाता है और दहन भद्रा पुच्छ में होता है। कुछ पंचांगों में एक दिन का अंतर हो सकता है।'),
  ),
  'holi': Info(
    Bi('Holi', 'होली'),
    Bi('The festival of colours, on the day after Holika Dahan, celebrating spring and the triumph of good over evil.',
        'रंगों का पर्व, जो होलिका दहन के अगले दिन वसंत और अच्छाई की बुराई पर जीत के उत्सव के रूप में मनाया जाता है।'),
    Bi('Play with dry colours and gulal, share gujiya and sweets, and meet family and friends.',
        'सूखे रंग और गुलाल से होली खेलें, गुझिया और मिठाइयाँ बाँटें, और परिवार व मित्रों से मिलें।'),
    rule: Bi('The day after Holika Dahan.', 'होलिका दहन के अगले दिन।'),
  ),
  'chaitra_navratri': Info(
    Bi('Chaitra Navratri begins', 'चैत्र नवरात्रि आरंभ'),
    Bi('Nine nights of worship of Goddess Durga beginning on Chaitra Shukla Pratipada, which is also the Hindu new year (Ugadi, Gudi Padwa) in many regions.',
        'चैत्र शुक्ल प्रतिपदा से आरंभ होने वाली देवी दुर्गा की नौ रात्रियाँ; अनेक क्षेत्रों में यही हिंदू नववर्ष (उगादि, गुड़ी पड़वा) भी है।'),
    Bi('Set up the kalash (Ghatasthapana) in the morning, fast through the nine days, worship a form of the Goddess each day and honour young girls on Ashtami or Navami.',
        'सुबह कलश स्थापना (घटस्थापना) करें, नौ दिन व्रत रखें, प्रतिदिन देवी के एक स्वरूप की पूजा करें और अष्टमी या नवमी को कन्या पूजन करें।'),
    rule: Bi('The day on which Pratipada is present at sunrise.', 'वह दिन जब सूर्योदय के समय प्रतिपदा हो।'),
  ),
  'ram_navami': Info(
    Bi('Ram Navami', 'राम नवमी'),
    Bi('The birth of Lord Rama, on Chaitra Shukla Navami, at midday.',
        'चैत्र शुक्ल नवमी को मध्याह्न में भगवान श्रीराम का जन्मोत्सव।'),
    Bi('Fast, read the Ramayana or Ramcharitmanas, sing bhajans and celebrate the birth at midday with a cradle and prasad.',
        'व्रत रखें, रामायण या रामचरितमानस का पाठ करें, भजन गाएँ और मध्याह्न में पालना व प्रसाद के साथ जन्मोत्सव मनाएँ।'),
    rule: Bi('The day on which Navami covers madhyahna (midday). Vaishnava and ISKCON followers sometimes observe it a day later, as in 2026.',
        'वह दिन जब मध्याह्न में नवमी हो। वैष्णव और इस्कॉन परंपरा में यह कभी-कभी एक दिन बाद मनाई जाती है, जैसे 2026 में।'),
  ),
  'hanuman_jayanti': Info(
    Bi('Hanuman Jayanti', 'हनुमान जयंती'),
    Bi('The birth of Hanuman. In most of North India it is kept on Chaitra Purnima; some regions keep it on other dates.',
        'हनुमान जी का जन्मोत्सव। उत्तर भारत में अधिकतर चैत्र पूर्णिमा को मनाया जाता है; कुछ क्षेत्रों में अन्य तिथियों पर भी मनाया जाता है।'),
    Bi('Visit a Hanuman temple, recite the Hanuman Chalisa or Sundar Kand, and offer sindoor and laddoo.',
        'हनुमान मंदिर जाएँ, हनुमान चालीसा या सुंदरकांड का पाठ करें और सिंदूर व लड्डू अर्पित करें।'),
    rule: Bi('The day on which Chaitra Purnima is present at sunrise. Regional dates differ (for example Karnataka and Andhra Pradesh follow other months).',
        'वह दिन जब सूर्योदय के समय चैत्र पूर्णिमा हो। क्षेत्रीय तिथियाँ भिन्न हैं (जैसे कर्नाटक और आंध्र प्रदेश में अन्य महीने)।'),
  ),
  'akshaya_tritiya': Info(
    Bi('Akshaya Tritiya', 'अक्षय तृतीया'),
    Bi('Vaishakha Shukla Tritiya, a day believed to bring never-diminishing (akshaya) merit; also Parashurama Jayanti.',
        'वैशाख शुक्ल तृतीया, जिस दिन किए गए कर्मों का पुण्य अक्षय माना जाता है; इसी दिन परशुराम जयंती भी है।'),
    Bi('Worship Vishnu and Lakshmi, give charity, and begin new ventures; buying gold is a common custom.',
        'विष्णु और लक्ष्मी की पूजा करें, दान दें और नए कार्य आरंभ करें; सोना खरीदना प्रचलित परंपरा है।'),
    rule: Bi('The first day on which Tritiya covers at least 48 minutes of the forenoon (sunrise to midday).', 'पहला दिन जिसमें पूर्वाह्न (सूर्योदय से मध्याह्न) के कम से कम 48 मिनट तृतीया हो।'),
  ),
  'guru_purnima': Info(
    Bi('Guru Purnima', 'गुरु पूर्णिमा'),
    Bi('Ashadha Purnima, the day to honour one\'s teachers and sage Vyasa, who compiled the Vedas.',
        'आषाढ़ पूर्णिमा, गुरुजनों और वेदों के संकलनकर्ता महर्षि वेदव्यास के सम्मान का दिन।'),
    Bi('Pay respects to your guru, offer flowers and dakshina, study scripture and give charity.',
        'अपने गुरु को प्रणाम करें, पुष्प और दक्षिणा अर्पित करें, शास्त्र अध्ययन करें और दान दें।'),
    rule: Bi('The day on which Purnima is present at sunrise.', 'वह दिन जब सूर्योदय के समय पूर्णिमा हो।'),
  ),
  'raksha_bandhan': Info(
    Bi('Raksha Bandhan', 'रक्षा बंधन'),
    Bi('Shravana Purnima: sisters tie a rakhi on their brothers\' wrists and brothers promise to protect them.',
        'श्रावण पूर्णिमा: बहनें भाइयों की कलाई पर राखी बाँधती हैं और भाई उनकी रक्षा का वचन देते हैं।'),
    Bi('Tie the rakhi after puja and applying tilak, give sweets and gifts. Do not tie it during Bhadra.',
        'पूजा और तिलक के बाद राखी बाँधें, मिठाई और उपहार दें। भद्रा काल में राखी न बाँधें।'),
    rule: Bi('The day on which Purnima covers the daytime outside Bhadra (Vishti karana). The exact time of the day to tie the rakhi is after Bhadra ends.',
        'वह दिन जब भद्रा के बाहर दिन के समय पूर्णिमा हो। राखी बाँधने का समय भद्रा समाप्त होने के बाद है।'),
  ),
  'janmashtami': Info(
    Bi('Krishna Janmashtami', 'कृष्ण जन्माष्टमी'),
    Bi('The birth of Lord Krishna at midnight, on Shravana Krishna Ashtami (Bhadrapada Krishna in the North).',
        'श्रावण कृष्ण अष्टमी (उत्तर भारत में भाद्रपद कृष्ण अष्टमी) की मध्यरात्रि में भगवान श्रीकृष्ण का जन्मोत्सव।'),
    Bi('Fast until midnight, decorate a cradle, sing bhajans and break the fast after the birth puja. Dahi Handi is held the next day.',
        'मध्यरात्रि तक उपवास रखें, झूला सजाएँ, भजन गाएँ और जन्म पूजा के बाद व्रत खोलें। अगले दिन दही हांडी मनाई जाती है।'),
    rule: Bi('The day on which Ashtami covers most of the daylight (the Vaishnava, udaya Ashtami day). Smarta followers keep the day on which Ashtami is present at midnight, which can be the day before.',
        'वह दिन जब अष्टमी दिन के अधिकांश भाग में हो (वैष्णव, उदया अष्टमी का दिन)। स्मार्त परंपरा में मध्यरात्रि में अष्टमी वाला दिन माना जाता है, जो एक दिन पहले हो सकता है।'),
  ),
  'ganesh_chaturthi': Info(
    Bi('Ganesh Chaturthi', 'गणेश चतुर्थी'),
    Bi('The birthday of Lord Ganesha on Bhadrapada Shukla Chaturthi, beginning a festival of up to ten days.',
        'भाद्रपद शुक्ल चतुर्थी को भगवान गणेश का जन्मोत्सव, जिससे दस दिन तक चलने वाला उत्सव आरंभ होता है।'),
    Bi('Install a Ganesha idol at midday, offer modak, durva and red flowers, and immerse it at the end of the festival (Anant Chaturdashi). Avoid seeing the Moon this evening.',
        'मध्याह्न में गणेश प्रतिमा स्थापित करें, मोदक, दूर्वा और लाल फूल अर्पित करें और उत्सव के अंत (अनंत चतुर्दशी) पर विसर्जन करें। इस शाम चंद्रमा के दर्शन से बचें।'),
    rule: Bi('The day on which Chaturthi covers madhyahna.', 'वह दिन जब मध्याह्न में चतुर्थी हो।'),
  ),
  'sharad_navratri': Info(
    Bi('Sharad Navratri begins', 'शारदीय नवरात्रि आरंभ'),
    Bi('Nine nights of worship of Goddess Durga from Ashwin Shukla Pratipada, ending with Dussehra.',
        'आश्विन शुक्ल प्रतिपदा से आरंभ होने वाली देवी दुर्गा की नौ रात्रियाँ, जिनका समापन दशहरे पर होता है।'),
    Bi('Set up the kalash (Ghatasthapana), fast, worship a form of the Goddess each day, and honour young girls on Ashtami or Navami. In Bengal this is Durga Puja.',
        'कलश स्थापना (घटस्थापना) करें, व्रत रखें, प्रतिदिन देवी के एक स्वरूप की पूजा करें और अष्टमी या नवमी को कन्या पूजन करें। बंगाल में यह दुर्गा पूजा है।'),
    rule: Bi('The day on which Pratipada is present at sunrise.', 'वह दिन जब सूर्योदय के समय प्रतिपदा हो।'),
  ),
  'durga_ashtami': Info(
    Bi('Durga Ashtami (Maha Ashtami)', 'दुर्गा अष्टमी (महाष्टमी)'),
    Bi('The eighth day of Navratri, the peak of the Goddess\'s worship, with Kanya Pujan.',
        'नवरात्रि का आठवाँ दिन, देवी पूजा का शिखर, जिस दिन कन्या पूजन होता है।'),
    Bi('Fast, worship Durga, and honour nine young girls with food and gifts.',
        'व्रत रखें, दुर्गा जी की पूजा करें और नौ कन्याओं को भोजन व उपहार से सम्मानित करें।'),
    rule: Bi('The day on which Ashtami is present at sunrise.', 'वह दिन जब सूर्योदय के समय अष्टमी हो।'),
  ),
  'dussehra': Info(
    Bi('Dussehra (Vijayadashami)', 'दशहरा (विजयादशमी)'),
    Bi('Ashwin Shukla Dashami, the victory of Rama over Ravana and of Durga over Mahishasura.',
        'आश्विन शुक्ल दशमी, श्रीराम की रावण पर और देवी दुर्गा की महिषासुर पर विजय का पर्व।'),
    Bi('Worship weapons and tools (Shastra Puja), the Shami tree and Aparajita; burn effigies of Ravana in the evening, and begin new ventures.',
        'शस्त्र और उपकरणों की पूजा (शस्त्र पूजन), शमी और अपराजिता की पूजा करें; संध्या को रावण दहन देखें और नए कार्य आरंभ करें।'),
    rule: Bi('The day on which Dashami covers aparahna (the afternoon), the Vijaya muhurta.', 'वह दिन जब अपराह्न (विजय मुहूर्त) में दशमी हो।'),
  ),
  'karwa_chauth': Info(
    Bi('Karwa Chauth', 'करवा चौथ'),
    Bi('Married women fast from sunrise to moonrise, without food or water, for the long life of their husbands. It falls on Krishna Chaturthi of Ashwin (Kartika in the North).',
        'विवाहित महिलाएँ पति की दीर्घायु के लिए सूर्योदय से चंद्रोदय तक निराहार और निर्जल व्रत रखती हैं। यह आश्विन (उत्तर भारत में कार्तिक) कृष्ण चतुर्थी को पड़ता है।'),
    Bi('Eat sargi before dawn, hear the Karwa Chauth katha in the evening, offer water to the Moon at moonrise, look at it through a sieve and then at the husband, who gives the first sip of water.',
        'भोर से पहले सरगी खाएँ, शाम को करवा चौथ की कथा सुनें, चंद्रोदय पर चंद्रमा को अर्घ्य दें, छलनी से चंद्रमा और फिर पति को देखें, और पति के हाथ से पहला घूँट जल पीकर व्रत खोलें।'),
    rule: Bi('The day on which Chaturthi is present at moonrise. The moonrise time is shown for your city; it varies by place.',
        'वह दिन जब चंद्रोदय के समय चतुर्थी हो। चंद्रोदय का समय आपके शहर के लिए दिखाया गया है; यह स्थान के अनुसार बदलता है।'),
  ),
  'dhanteras': Info(
    Bi('Dhanteras', 'धनतेरस'),
    Bi('Dhantrayodashi, the first day of Diwali, on Trayodashi of the dark fortnight. It honours Dhanvantari, the god of health, and Lakshmi and Kubera.',
        'दीपावली का पहला दिन, कृष्ण पक्ष की त्रयोदशी। यह आरोग्य के देवता धन्वंतरि तथा लक्ष्मी व कुबेर के पूजन का दिन है।'),
    Bi('Buy gold, silver or new utensils, worship Lakshmi and Kubera in the pradosh time, and light a lamp for Yama at dusk (Yamadeepdan).',
        'सोना, चाँदी या नए बर्तन खरीदें, प्रदोष काल में लक्ष्मी-कुबेर की पूजा करें और संध्या को यमदीपदान करें।'),
    rule: Bi('The day on which Trayodashi covers pradosh.', 'वह दिन जब प्रदोष में त्रयोदशी हो।'),
  ),
  'diwali': Info(
    Bi('Diwali (Lakshmi Puja)', 'दीपावली (लक्ष्मी पूजन)'),
    Bi('The festival of lights on the new moon of Ashwin (Kartika in the North), the return of Rama to Ayodhya and the worship of Lakshmi.',
        'आश्विन (उत्तर भारत में कार्तिक) की अमावस्या का दीपोत्सव, श्रीराम की अयोध्या वापसी और लक्ष्मी पूजन का पर्व।'),
    Bi('Clean and decorate the house, draw rangoli, light lamps, worship Lakshmi and Ganesha in the pradosh time, and share sweets.',
        'घर की सफ़ाई और सजावट करें, रंगोली बनाएँ, दीप जलाएँ, प्रदोष काल में लक्ष्मी-गणेश की पूजा करें और मिठाइयाँ बाँटें।'),
    rule: Bi('The day on which Amavasya covers pradosh. If Amavasya covers pradosh on two days, the day with the longer overlap.',
        'वह दिन जब प्रदोष में अमावस्या हो। यदि दो दिन प्रदोष में अमावस्या हो, तो जिस दिन अधिक समय हो।'),
  ),
  'govardhan_puja': Info(
    Bi('Govardhan Puja', 'गोवर्धन पूजा'),
    Bi('The day after Diwali (Kartika Shukla Pratipada), recalling Krishna lifting Mount Govardhan. Annakut, a mountain of food, is offered.',
        'दीपावली के अगले दिन (कार्तिक शुक्ल प्रतिपदा), श्रीकृष्ण द्वारा गोवर्धन पर्वत उठाने की स्मृति में; अन्नकूट का भोग लगाया जाता है।'),
    Bi('Make a Govardhan hill of cow dung, worship it and the cows, and offer Annakut.',
        'गोबर से गोवर्धन बनाकर उसकी और गायों की पूजा करें और अन्नकूट का भोग लगाएँ।'),
    rule: Bi('The day on which Pratipada is present at sunrise.', 'वह दिन जब सूर्योदय के समय प्रतिपदा हो।'),
  ),
  'bhai_dooj': Info(
    Bi('Bhai Dooj', 'भाई दूज'),
    Bi('Kartika Shukla Dwitiya: sisters pray for the long life of their brothers.',
        'कार्तिक शुक्ल द्वितीया: बहनें भाइयों की दीर्घायु की कामना करती हैं।'),
    Bi('Sisters apply tilak on their brothers\' foreheads, offer sweets and a meal, and brothers give gifts.',
        'बहनें भाइयों के माथे पर तिलक लगाती हैं, मिठाई और भोजन कराती हैं और भाई उपहार देते हैं।'),
    rule: Bi('The day on which Dwitiya covers aparahna (the afternoon), the tilak time.', 'वह दिन जब अपराह्न (तिलक के समय) में द्वितीया हो।'),
  ),
  'chhath': Info(
    Bi('Chhath Puja (Sandhya Arghya)', 'छठ पूजा (संध्या अर्घ्य)'),
    Bi('A four-day worship of the Sun and Chhathi Maiya, mainly in Bihar, Jharkhand and eastern Uttar Pradesh. The main day, Kartika Shukla Shashthi, has the evening offering to the setting Sun.',
        'सूर्य देव और छठी मैया की चार दिवसीय पूजा, मुख्यतः बिहार, झारखंड और पूर्वी उत्तर प्रदेश में। मुख्य दिन कार्तिक शुक्ल षष्ठी को अस्त होते सूर्य को संध्या अर्घ्य दिया जाता है।'),
    Bi('Fast for about 36 hours without water, stand in a river or pond and offer arghya with fruit and thekua to the setting Sun, and again to the rising Sun next morning.',
        'लगभग 36 घंटे निर्जला उपवास रखें, नदी या तालाब में खड़े होकर फल और ठेकुआ के साथ अस्त होते सूर्य को और अगली सुबह उदय होते सूर्य को अर्घ्य दें।'),
    rule: Bi('The day on which Shashthi covers the daytime up to sunset. This is the Sandhya Arghya day; the four days start two days before.',
        'वह दिन जब सूर्यास्त तक दिन में षष्ठी हो। यही संध्या अर्घ्य का दिन है; चार दिन का पर्व दो दिन पहले आरंभ होता है।'),
  ),
};

/// The info for an observance; Ekadashi gets its own name and note.
Info infoOf(Observance o) {
  final base = catalog[o.id]!;
  final v = o.variant == null ? null : ekadashiNames[o.variant];
  if (v == null) return base;
  return Info(
    v.$1,
    Bi('${v.$2.en}\n\n${base.about.en}', '${v.$2.hi}\n\n${base.about.hi}'),
    base.observe,
    rule: base.rule,
  );
}

/// The display name of an observance.
Bi nameOf(Observance o) => infoOf(o).name;
