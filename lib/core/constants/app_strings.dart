class AppStrings {
  AppStrings._();

  // ── App ───────────────────────────────────────────────────────────────────
  static const String appName = 'IMPOSTER';
  static const String appSubtitle = 'Kerala Edition';
  static const String appTagline = 'കള്ളൻ നിങ്ങളുടെ ഇടയിൽ ഉണ്ട്...';

  // ── Home Screen ───────────────────────────────────────────────────────────
  static const String startGame = 'Start Game';
  static const String howToPlay = 'How To Play';
  static const String settings = 'Settings';

  // ── Setup Screen ──────────────────────────────────────────────────────────
  static const String gameSetup = 'Game Setup';
  static const String numberOfPlayers = 'Number of Players';
  static const String numberOfImposters = 'Number of Imposters';
  static const String discussionTime = 'Discussion Time';
  static const String selectCategories = 'Select Categories';
  static const String startGameButton = '🎮 Start Game';
  static const String playerNames = 'Player Names';
  static const String playerHint = 'Player';
  static const String min1 = '1 Min';
  static const String min2 = '2 Min';
  static const String min3 = '3 Min';
  static const String min5 = '5 Min';

  // ── Role Reveal Screen ───────────────────────────────────────────────────
  static const String tapAndHold = 'Tap & Hold to Reveal';
  static const String holdingToReveal = 'Revealing...';
  static const String hideAndPass = 'Hide & Pass Phone';
  static const String passPhoneMessage = 'Pass the phone to';
  static const String secretCategory = 'Category';
  static const String yourWord = 'Your Word';
  static const String roleRevealed = 'Role Revealed';
  static const String youAreImposter = 'YOU ARE THE\nIMPOSTER';
  static const String wordHidden = '???';
  static const String wordHiddenSubtext = 'Figure it out! 😈';

  // ── Normal Player Messages ────────────────────────────────────────────────
  static const String normalSubtext = 'കള്ളനെ കണ്ടെത്തണം 😎';
  static const String normalHint = 'Remember your word. Don\'t reveal it!';

  // ── Imposter Messages (random pick) ──────────────────────────────────────
  static const List<String> imposterMessages = [
    'അറിയാത്ത പോലെ അഭിനയിക്ക് മോനെ 😎',
    'ഇനി രക്ഷപ്പെടാൻ നോക്ക് 😂',
    'കുറച്ച് ബുദ്ധി ഉപയോഗിക്കണം 🤨',
    'ഭാഗ്യം ഉണ്ടെങ്കിൽ രക്ഷപ്പെടും 🙃',
    'ഇവർ നിന്നെ കണ്ടെത്തും... അല്ലെങ്കിൽ ഇല്ല 😏',
  ];

  // ── Discussion Screen ─────────────────────────────────────────────────────
  static const String discussionTime2 = 'DISCUSSION\nTIME';
  static const String discussionSubtitle = 'Find the Imposter!';
  static const List<String> discussionMessages = [
    'കള്ളൻ നിങ്ങളുടെ ഇടയിൽ ഉണ്ട് 👀',
    'ആരെയും വിശ്വസിക്കണ്ട 🤨',
    'വളരെ നിശബ്ദം... സംശയം 😏',
    'സത്യം പറയടാ മോനെ 😂',
    'ഒരുത്തൻ കള്ളൻ ഉണ്ട് ഇവിടെ 🕵️',
    'ആരാ ഇത്ര nervous ആയിരിക്കുന്നത്? 🫣',
  ];
  static const String timeUp = 'TIME\'S UP!';
  static const String proceedToVote = 'Proceed to Vote';
  static const String skipTimer = 'Skip Timer';

  // ── Voting Screen ─────────────────────────────────────────────────────────
  static const String votingTitle = 'VOTE THE\nIMPOSTER';
  static const String votingSubtitle = 'Tap a player to vote';
  static const String confirmVote = 'Confirm Vote';
  static const String votingInProgress = 'Who is the Imposter?';
  static const String selectPlayer = 'Select a player to vote';

  // ── Result Screen ─────────────────────────────────────────────────────────
  static const String imposterCaught = '🎉 കള്ളനെ പൊക്കി!';
  static const String imposterWins = '😈 എല്ലാവരെയും പറ്റിച്ചു!';
  static const String wasTheImposter = 'was the Imposter!';
  static const String theWordWas = 'The secret word was';
  static const String playAgain = '🔄 Play Again';
  static const String backToHome = '🏠 Back to Home';

  static const List<String> caughtSubtitles = [
    'CID മോഡിൽ കളിച്ചു 😎',
    'Detective level: Kerala 🕵️',
    'ഒറ്റയടിക്ക് കണ്ടെത്തി! 🎯',
    'ഇവർ കണ്ണടക്കൂ... ഇവർ കാണും 👁️',
  ];

  static const List<String> imposterWinsSubtitles = [
    'ഓസ്കാർ കൊടുക്കണം ഈ അഭിനയത്തിന് 😂',
    'നടൻ/നടി ഓഫ് ദ ഇയർ 🏆',
    'Imposter Level: Pro 😈',
    'Fahadh Faasil ആകണ്ട, ഇവൻ മതി! 🎭',
  ];

  // ── Settings Screen ───────────────────────────────────────────────────────
  static const String settingsTitle = 'Settings';
  static const String language = 'Language';
  static const String theme = 'Theme';
  static const String vibration = 'Vibration';
  static const String sound = 'Sound';
  static const String english = 'English';
  static const String malayalam = 'Malayalam';
  static const String darkTheme = 'Dark';
  static const String lightTheme = 'Light';
  static const String on = 'On';
  static const String off = 'Off';

  // ── How To Play ───────────────────────────────────────────────────────────
  static const String howToPlayTitle = 'How To Play';
  static const List<Map<String, String>> howToPlaySteps = [
    {
      'icon': '⚙️',
      'title': 'Setup the Game',
      'desc': 'Choose the number of players, imposters, discussion time, and categories.',
    },
    {
      'icon': '📱',
      'title': 'Pass the Phone',
      'desc': 'Each player secretly views their role by holding the reveal button.',
    },
    {
      'icon': '🃏',
      'title': 'Know Your Role',
      'desc': 'Normal players see the secret word. Imposters see "???" — they must bluff!',
    },
    {
      'icon': '💬',
      'title': 'Discuss',
      'desc': 'Everyone talks about the word without saying it directly. Find inconsistencies!',
    },
    {
      'icon': '🗳️',
      'title': 'Vote',
      'desc': 'Vote for who you think the Imposter is. Majority wins!',
    },
    {
      'icon': '🏆',
      'title': 'Result',
      'desc': 'If the Imposter is caught, everyone wins! If not — the Imposter wins!',
    },
  ];
}

// ── Category Data ─────────────────────────────────────────────────────────────
class CategoryData {
  static const List<Map<String, dynamic>> categories = [
    {
      'id': 'malayalam_movies',
      'name': 'Malayalam Movies',
      'nameML': 'മലയാളം സിനിമ',
      'icon': '🎬',
      'words': [
        'Premam', 'Drishyam', 'Lucifer', 'Aavesham', 'Manjummel Boys',
        'CID Moosa', 'Minnal Murali', 'Bangalore Days', 'Kumbalangi Nights',
        'Thallumaala', 'Hridayam', 'Aadujeevitham', 'Maheshinte Prathikaram',
        'Angamaly Diaries', 'C U Soon', 'Joji', 'Malik', 'Naradan',
        'Bheeshma Parvam', 'Varshangalkku Shesham',
      ],
    },
    {
      'id': 'malayalam_actors',
      'name': 'Malayalam Actors',
      'nameML': 'മലയാളം നടന്മാർ',
      'icon': '🎭',
      'words': [
        'Mohanlal', 'Mammootty', 'Fahadh Faasil', 'Prithviraj', 'Nivin Pauly',
        'Tovino Thomas', 'Dileep', 'Asif Ali', 'Biju Menon', 'Jayaram',
        'Suresh Gopi', 'Dulquer Salmaan', 'Shane Nigam', 'Roshan Mathew',
        'Soubin Shahir', 'Naslen', 'Basil Paulose', 'Unni Mukundan',
      ],
    },
    {
      'id': 'kerala_food',
      'name': 'Kerala Food',
      'nameML': 'കേരള ഭക്ഷണം',
      'icon': '🍛',
      'words': [
        'Porotta', 'Beef Fry', 'Puttu', 'Kadala', 'Appam', 'Biriyani',
        'Pazhampori', 'Sadhya', 'Pathiri', 'Kanji', 'Meen Curry',
        'Aviyal', 'Kappa', 'Idiyappam', 'Palada', 'Unniyappam',
        'Kozhikode Halwa', 'Pazham Pori', 'Kallummakkaya',
      ],
    },
    {
      'id': 'football',
      'name': 'Football',
      'nameML': 'ഫുട്ബോൾ',
      'icon': '⚽',
      'words': [
        'Messi', 'Ronaldo', 'Argentina', 'Brazil', 'World Cup',
        'Kerala Blasters', 'Neymar', 'Mbappe', 'Haaland', 'Vinicius',
        'Real Madrid', 'Barcelona', 'Manchester City', 'Premier League',
        'Champions League', 'La Liga', 'ISL', 'Mohun Bagan',
      ],
    },
    {
      'id': 'kerala_places',
      'name': 'Kerala Places',
      'nameML': 'കേരള സ്ഥലങ്ങൾ',
      'icon': '🏝️',
      'words': [
        'Wayanad', 'Kozhikode', 'Munnar', 'Bekal', 'Vagamon', 'Alappuzha',
        'Athirappilly', 'Varkala', 'Thrissur', 'Kochi', 'Trivandrum',
        'Sabarimala', 'Guruvayur', 'Cherai Beach', 'Fort Kochi',
        'Eravikulam', 'Periyar', 'Kumarakom', 'Poovar',
      ],
    },
    {
      'id': 'kerala_life',
      'name': 'Kerala Life',
      'nameML': 'കേരള ജീവിതം',
      'icon': '😂',
      'words': [
        'KSRTC', 'Chaya Kada', 'Auto Chettan', 'Gulf', 'Onam', 'Pooram',
        'Mazha', 'Coconut Tree', 'Harthal', 'Rubber', 'Toddy Shop',
        'Mundu', 'Kasavu Saree', 'Elephant', 'Theyyam', 'Kalaripayattu',
        'Aluva Puzha', 'Vallam Kali', 'Payasam',
      ],
    },
    {
      'id': 'malayalam_songs',
      'name': 'Malayalam Songs',
      'nameML': 'മലയാളം പാട്ടുകൾ',
      'icon': '🎵',
      'words': [
        'Malare', 'Ormayundo Ee Mugham', 'Jeevamshamayi', 'Ente Mohangal',
        'Poomaram', 'Karikkin Vellam', 'Mizhiyoram', 'Oru Murai Vanthu',
        'Dynamite', 'Chundari Penne', 'Thumbi Vaa', 'Nenjame',
        'Enthinu Nee Vanthithu', 'Minungum Minnaminunge', 'Kandu Kandu',
      ],
    },
  ];
}
