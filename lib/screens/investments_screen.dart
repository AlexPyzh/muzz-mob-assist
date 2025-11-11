import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:muzzbirzha_mobile/models/investment.dart';
import 'package:muzzbirzha_mobile/providers/auth_provider.dart';
import 'package:muzzbirzha_mobile/providers/invest_provider.dart';
import 'package:muzzbirzha_mobile/providers/track_list_provider.dart';
import 'package:muzzbirzha_mobile/network/muzz_client.dart';
import 'package:muzzbirzha_mobile/consts/paths.dart';
import 'package:muzzbirzha_mobile/screens/track_investments.dart';

// For CSV export & tab persistence
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InvestmentsScreen extends StatefulWidget {
  const InvestmentsScreen({super.key});

  @override
  State<InvestmentsScreen> createState() => _InvestmentsScreenState();
}

class _InvestmentsScreenState extends State<InvestmentsScreen>
    with SingleTickerProviderStateMixin {
  late final AuthProvider authProvider;
  late final InvestProvider investProvider;

  int? _sortColumnIndex;
  bool _sortAscending = true;
  String _query = '';

  TabController? _tabController;
  static const _tabPrefKey = 'investments_tab_index';

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    investProvider = Provider.of<InvestProvider>(context, listen: false);
    _initTabs();
    if (authProvider.isLoggedIn) {
      _loadInvestments(authProvider.loggedInUser.id!);
    }
  }

  Future<void> _initTabs() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getInt(_tabPrefKey) ?? 0;
    _tabController =
        TabController(length: 2, vsync: this, initialIndex: saved.clamp(0, 1));
    _tabController?.addListener(() {
      if (_tabController?.indexIsChanging == true) return;
      _saveTabIndex(_tabController?.index ?? 0);
    });
    if (mounted) setState(() {});
  }

  Future<void> _saveTabIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_tabPrefKey, index);
  }

  void _loadInvestments(int userId) async {
    investProvider.investments =
        await MuzzClient().getUnitedUserInvestments(userId);
  }

  List<Investment> _sorted(List<Investment> data) {
    var list = List<Investment>.from(data);
    final idx = _sortColumnIndex;
    int cmp(String a, String b) => a.toLowerCase().compareTo(b.toLowerCase());
    int numCmp(num a, num b) => a.compareTo(b);

    if (idx == 0) {
      list.sort((a, b) => cmp(a.track?.name ?? '', b.track?.name ?? ''));
    } else if (idx == 1) {
      list.sort((a, b) =>
          cmp(a.track?.artist?.name ?? '', b.track?.artist?.name ?? ''));
    } else if (idx == 2) {
      list.sort((a, b) => numCmp(a.boughtPercent ?? 0, b.boughtPercent ?? 0));
    }
    if (!_sortAscending) {
      list = list.reversed.toList();
    }
    return list;
  }

  List<Investment> _filtered(List<Investment> data) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return data;
    return data.where((inv) {
      final trackName = inv.track?.name?.toLowerCase() ?? '';
      final artistName = inv.track?.artist?.name?.toLowerCase() ?? '';
      return trackName.contains(q) || artistName.contains(q);
    }).toList();
  }

  double _totalPercent(Iterable<Investment> data) {
    double sum = 0;
    for (final inv in data) {
      final v = inv.boughtPercent;
      if (v != null) sum += v;
    }
    return sum;
  }

  void _onSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  Future<void> _exportCsv(List<Investment> data) async {
    final buf = StringBuffer();
    buf.writeln('Track,Artist,Bought %');
    String esc(String s) {
      final q = s.replaceAll('"', '""');
      return '"$q"';
    }

    for (final inv in data) {
      final trackName = inv.track?.name ?? '';
      final artistName = inv.track?.artist?.name ?? '';
      final percent = (inv.boughtPercent ?? 0).toString();
      buf.writeln('${esc(trackName)},${esc(artistName)},$percent');
    }
    final dir = await getTemporaryDirectory();
    final now = DateTime.now();
    String two(int n) => n.toString().padLeft(2, '0');
    final ts =
        '${now.year}-${two(now.month)}-${two(now.day)}_${two(now.hour)}-${two(now.minute)}';
    final file = File('${dir.path}/investments_$ts.csv');
    await file.writeAsString(buf.toString());
    await Share.shareXFiles([XFile(file.path)], text: 'My investments (CSV)');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'My invesments',
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          actions: [
            IconButton(
              tooltip: 'Export CSV',
              icon: const Icon(Icons.download),
              onPressed: () async {
                final provider = context.read<InvestProvider>();
                final raw = provider.investments ?? [];
                final filteredSorted = _filtered(_sorted(raw));
                await _exportCsv(filteredSorted);
              },
            ),
          ],
          bottom: _tabController != null
              ? TabBar(
                  controller: _tabController!,
                  tabs: const [
                    Tab(text: 'Table'),
                    Tab(text: 'Cards'),
                  ],
                )
              : null,
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Live filter field
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: TextField(
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search by track or artist...',
                    filled: true,
                    fillColor: const Color(0xff1a1b1e),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Consumer<InvestProvider>(
                  builder: (context, value, _) {
                    final invests = value.investments;
                    if (invests == null) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (invests.isEmpty) {
                      return const Center(child: Text('No investments yet'));
                    }

                    final data = _filtered(_sorted(invests));
                    final total = _totalPercent(data);

                    return _tabController != null
                        ? TabBarView(
                            controller: _tabController!,
                            children: [
                              // ------ Table view ------
                              SingleChildScrollView(
                                padding: const EdgeInsets.all(16),
                                scrollDirection: Axis.vertical,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    sortColumnIndex: _sortColumnIndex,
                                    sortAscending: _sortAscending,
                                    headingRowColor: WidgetStateProperty.all(
                                        const Color(0xff1a1b1e)),
                                    columns: [
                                      DataColumn(
                                        label: const Text('Track',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xfff2c900))),
                                        onSort: (i, asc) => _onSort(0, asc),
                                      ),
                                      DataColumn(
                                        label: const Text('Artist',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xfff2c900))),
                                        onSort: (i, asc) => _onSort(1, asc),
                                      ),
                                      DataColumn(
                                        label: const Text('Bought %',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xfff2c900))),
                                        numeric: true,
                                        onSort: (i, asc) => _onSort(2, asc),
                                      ),
                                    ],
                                    rows: [
                                      ...data.map((inv) {
                                        final track = inv.track;
                                        final artist = track?.artist;
                                        final trackImage =
                                            track?.imageUrl ?? '';
                                        final artistImage =
                                            artist?.imageUrl ?? '';
                                        final trackName = track?.name ?? '—';
                                        final artistName = artist?.name ?? '—';
                                        final percent =
                                            (inv.boughtPercent ?? 0).toString();

                                        final trackThumb = ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: trackImage.isNotEmpty
                                              ? Image.network(
                                                  trackImage,
                                                  width: 40,
                                                  height: 40,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (_, __, ___) =>
                                                      const Icon(
                                                          Icons.music_note),
                                                )
                                              : const SizedBox(
                                                  width: 40,
                                                  height: 40,
                                                  child: DecoratedBox(
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Color(0xff2a2b2e)),
                                                    child:
                                                        Icon(Icons.music_note),
                                                  ),
                                                ),
                                        );

                                        final artistThumb = CircleAvatar(
                                          radius: 20,
                                          backgroundImage:
                                              artistImage.isNotEmpty
                                                  ? NetworkImage(artistImage)
                                                  : null,
                                          child: artistImage.isEmpty
                                              ? const Icon(Icons.person)
                                              : null,
                                        );

                                        return DataRow(
                                          cells: [
                                            // Track cell (tap to play)
                                            DataCell(
                                              InkWell(
                                                onTap: () {
                                                  final tlp = context.read<
                                                      TrackListProvider>();
                                                  final tracks = data
                                                      .map((e) => e.track!)
                                                      .toList();
                                                  final idx = data.indexOf(inv);
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                    builder: (_) =>
                                                        TrackInvestmentsScreen(
                                                      track: track!,
                                                      investment: inv,
                                                    ),
                                                  ));
                                                },
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    trackThumb,
                                                    const SizedBox(width: 10),
                                                    ConstrainedBox(
                                                      constraints:
                                                          const BoxConstraints(
                                                              maxWidth: 240),
                                                      child: Text(trackName,
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            // Artist cell (tap to artist screen)
                                            DataCell(
                                              GestureDetector(
                                                onTap: () {
                                                  final artistId = artist?.id;
                                                  if (artistId != null) {
                                                    Navigator.of(context)
                                                        .pushNamed(
                                                            artistScreenPath,
                                                            arguments:
                                                                artistId);
                                                  }
                                                },
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    artistThumb,
                                                    const SizedBox(width: 10),
                                                    ConstrainedBox(
                                                      constraints:
                                                          const BoxConstraints(
                                                              maxWidth: 200),
                                                      child: Text(artistName,
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            DataCell(Text(percent)),
                                          ],
                                        );
                                      }),
                                      // Total row - left aligned in first cell
                                      DataRow(
                                        cells: [
                                          DataCell(Text(
                                            'Total: ' +
                                                total.toStringAsFixed(2),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xfff2c900)),
                                          )),
                                          const DataCell(Text('')),
                                          const DataCell(Text('')),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // ------ Cards view ------
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    final isWide = constraints.maxWidth > 700;
                                    final crossAxisCount = isWide ? 3 : 1;
                                    return Column(
                                      children: [
                                        Expanded(
                                          child: GridView.builder(
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: crossAxisCount,
                                              crossAxisSpacing: 12,
                                              mainAxisSpacing: 12,
                                              childAspectRatio:
                                                  isWide ? 2.6 : 2.2,
                                            ),
                                            itemCount: data.length,
                                            itemBuilder: (context, i) {
                                              final inv = data[i];
                                              final track = inv.track;
                                              final artist = track?.artist;
                                              final trackImage =
                                                  track?.imageUrl ?? '';
                                              final artistImage =
                                                  artist?.imageUrl ?? '';
                                              final trackName =
                                                  track?.name ?? '—';
                                              final artistName =
                                                  artist?.name ?? '—';
                                              final percent =
                                                  (inv.boughtPercent ?? 0)
                                                      .toString();

                                              return Card(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: Row(
                                                    children: [
                                                      // image (tap to play)
                                                      GestureDetector(
                                                        onTap: () {
                                                          final tlp = context.read<
                                                              TrackListProvider>();
                                                          final tracks = data
                                                              .map((e) =>
                                                                  e.track!)
                                                              .toList();
                                                          final idx = i;
                                                          Navigator.of(context)
                                                              .push(
                                                                  MaterialPageRoute(
                                                            builder: (_) =>
                                                                TrackInvestmentsScreen(
                                                              track: track!,
                                                              investment: inv,
                                                            ),
                                                          ));
                                                        },
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          child: trackImage
                                                                  .isNotEmpty
                                                              ? Image.network(
                                                                  trackImage,
                                                                  width: 72,
                                                                  height: 72,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  errorBuilder: (_,
                                                                          __,
                                                                          ___) =>
                                                                      const Icon(
                                                                          Icons
                                                                              .music_note,
                                                                          size:
                                                                              40),
                                                                )
                                                              : const SizedBox(
                                                                  width: 72,
                                                                  height: 72,
                                                                  child:
                                                                      DecoratedBox(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            color:
                                                                                Color(0xff2a2b2e)),
                                                                    child: Icon(
                                                                        Icons
                                                                            .music_note,
                                                                        size:
                                                                            40),
                                                                  ),
                                                                ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 12),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            // title (tap to play)
                                                            GestureDetector(
                                                              onTap: () {
                                                                final tlp =
                                                                    context.read<
                                                                        TrackListProvider>();
                                                                final tracks = data
                                                                    .map((e) =>
                                                                        e.track!)
                                                                    .toList();
                                                                final idx = i;
                                                                Navigator.of(
                                                                        context)
                                                                    .push(
                                                                        MaterialPageRoute(
                                                                  builder: (_) =>
                                                                      TrackInvestmentsScreen(
                                                                    track:
                                                                        track!,
                                                                    investment:
                                                                        inv,
                                                                  ),
                                                                ));
                                                              },
                                                              child: Text(
                                                                  trackName,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .titleMedium,
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis),
                                                            ),
                                                            const SizedBox(
                                                                height: 4),
                                                            Row(
                                                              children: [
                                                                // artist avatar (tap to artist)
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    final artistId =
                                                                        artist
                                                                            ?.id;
                                                                    if (artistId !=
                                                                        null) {
                                                                      Navigator.of(context).pushNamed(
                                                                          artistScreenPath,
                                                                          arguments:
                                                                              artistId);
                                                                    }
                                                                  },
                                                                  child:
                                                                      CircleAvatar(
                                                                    radius: 14,
                                                                    backgroundImage: artistImage
                                                                            .isNotEmpty
                                                                        ? NetworkImage(
                                                                            artistImage)
                                                                        : null,
                                                                    child: artistImage
                                                                            .isEmpty
                                                                        ? const Icon(
                                                                            Icons
                                                                                .person,
                                                                            size:
                                                                                16)
                                                                        : null,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    width: 8),
                                                                // artist name (tap to artist)
                                                                Expanded(
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      final artistId =
                                                                          artist
                                                                              ?.id;
                                                                      if (artistId !=
                                                                          null) {
                                                                        Navigator.of(context).pushNamed(
                                                                            artistScreenPath,
                                                                            arguments:
                                                                                artistId);
                                                                      }
                                                                    },
                                                                    child: Text(
                                                                        artistName,
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(width: 12),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 10,
                                                                vertical: 6),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color(
                                                              0xff1a1b1e),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      999),
                                                        ),
                                                        child: Text(
                                                            '$percent %',
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xfff2c900))),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        // Total left-aligned under grid
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(top: 8),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 14, vertical: 10),
                                            decoration: BoxDecoration(
                                              color: const Color(0xff1a1b1e),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Text('Total: ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xfff2c900))),
                                                Text(total.toStringAsFixed(2),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xfff2c900))),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          )
                        : const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
}
