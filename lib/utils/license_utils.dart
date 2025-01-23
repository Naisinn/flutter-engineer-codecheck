// utils/license_utils.dart
import 'package:flutter/material.dart';

class LicenseUtils {
  static final Map<String, Map<String, dynamic>> licenseMap = {
    'mit license': {
      'icon': Icons.verified,
      'color': Colors.green,
      'url': 'https://opensource.org/licenses/MIT',
      'abbreviation': 'MIT',
    },
    'apache license 2.0': {
      'icon': Icons.business,
      'color': Colors.blue,
      'url': 'https://www.apache.org/licenses/LICENSE-2.0',
      'abbreviation': 'Apache 2.0',
    },
    'gnu general public license v3.0': {
      'icon': Icons.gavel,
      'color': Colors.red,
      'url': 'https://www.gnu.org/licenses/gpl-3.0.en.html',
      'abbreviation': 'GPLv3',
    },
    'gnu lesser general public license v3.0': {
      'icon': Icons.handshake,
      'color': Colors.orange,
      'url': 'https://www.gnu.org/licenses/lgpl-3.0.en.html',
      'abbreviation': 'LGPLv3',
    },
    'gnu affero general public license v3.0': {
      'icon': Icons.public,
      'color': Colors.deepOrange,
      'url': 'https://www.gnu.org/licenses/agpl-3.0.en.html',
      'abbreviation': 'AGPLv3',
    },
    'bsd 2-clause "simplified" license': {
      'icon': Icons.assignment,
      'color': Colors.teal,
      'url': 'https://opensource.org/licenses/BSD-2-Clause',
      'abbreviation': 'BSD 2-Clause',
    },
    'bsd 3-clause "new" or "revised" license': {
      'icon': Icons.assignment,
      'color': Colors.orange,
      'url': 'https://opensource.org/licenses/BSD-3-Clause',
      'abbreviation': 'BSD 3-Clause',
    },
    'mozilla public license 2.0': {
      'icon': Icons.security,
      'color': Colors.purple,
      'url': 'https://www.mozilla.org/en-US/MPL/2.0/',
      'abbreviation': 'MPL 2.0',
    },
    'eclipse public license 2.0': {
      'icon': Icons.lightbulb,
      'color': Colors.indigo,
      'url': 'https://www.eclipse.org/legal/epl-2.0/',
      'abbreviation': 'EPL 2.0',
    },
    'isc license': {
      'icon': Icons.eco,
      'color': Colors.lime,
      'url': 'https://opensource.org/licenses/ISC',
      'abbreviation': 'ISC',
    },
    'boost software license 1.0': {
      'icon': Icons.code,
      'color': Colors.blueGrey,
      'url': 'https://www.boost.org/LICENSE_1_0.txt',
      'abbreviation': 'Boost 1.0',
    },
    'unlicense': {
      'icon': Icons.block,
      'color': Colors.grey,
      'url': 'http://unlicense.org/',
      'abbreviation': 'Unlicense',
    },
    'creative commons zero v1.0 universal': {
      'icon': Icons.public,
      'color': Colors.cyan,
      'url': 'https://creativecommons.org/publicdomain/zero/1.0/',
      'abbreviation': 'CC0 1.0',
    },
    'creative commons attribution 4.0 international': {
      'icon': Icons.share,
      'color': Colors.blueAccent,
      'url': 'https://creativecommons.org/licenses/by/4.0/',
      'abbreviation': 'CC BY 4.0',
    },
    'creative commons attribution share alike 4.0 international': {
      'icon': Icons.share,
      'color': Colors.blueAccent,
      'url': 'https://creativecommons.org/licenses/by-sa/4.0/',
      'abbreviation': 'CC BY-SA 4.0',
    },
    'artistic license 2.0': {
      'icon': Icons.brush,
      'color': Colors.pink,
      'url': 'https://opensource.org/licenses/Artistic-2.0',
      'abbreviation': 'Artistic 2.0',
    },
    'zlib license': {
      'icon': Icons.format_quote,
      'color': Colors.deepPurple,
      'url': 'https://opensource.org/licenses/Zlib',
      'abbreviation': 'Zlib',
    },
    'apache license 1.1': {
      'icon': Icons.business,
      'color': Colors.blue,
      'url': 'https://www.apache.org/licenses/LICENSE-1.1',
      'abbreviation': 'Apache 1.1',
    },
    'gnu free documentation license v1.3': {
      'icon': Icons.library_books,
      'color': Colors.brown,
      'url': 'https://www.gnu.org/licenses/fdl-1.3.html',
      'abbreviation': 'GFDL 1.3',
    },
    // 他にも必要なライセンスをここに追加できます
  };
}
