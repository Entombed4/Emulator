import 'package:flutter/material.dart';
import '../models/entry.dart';
import '../utils/storage.dart';
import '../widgets/entry_card.dart';
import 'create_entry_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Entry> _entries = [];
  String _searchQuery = '';
  bool _loading = true;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFromStorage();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFromStorage() async {
    final saved = await loadEntries();
    if (!mounted) return;
    setState(() {
      _entries = saved;
      _loading = false;
    });
  }

  List<Entry> get _filteredEntries {
    if (_searchQuery.isEmpty) return _entries;
    final query = _searchQuery.toLowerCase();
    return _entries.where((e) {
      return e.title.toLowerCase().contains(query) ||
          e.text.toLowerCase().contains(query) ||
          e.tags.any((t) => t.toLowerCase().contains(query));
    }).toList();
  }

  Future<void> _openCreateScreen() async {
    final newEntry = await Navigator.push<Entry>(
      context,
      MaterialPageRoute(builder: (_) => const CreateEntryScreen()),
    );
    if (newEntry != null) {
      setState(() {
        _entries.insert(0, newEntry);
        _entries.sort((a, b) => b.date.compareTo(a.date));
      });
      saveEntries(_entries);
    }
  }

  Future<bool> _confirmDelete() async {
    return await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete entry?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    ) ??
        false;
  }

  Widget _emptyState({required IconData icon, required String message, bool showButton = false}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 72, color: Colors.grey),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium),
            if (showButton) ...[
              const SizedBox(height: 16),
              FilledButton.tonal(
                onPressed: _openCreateScreen,
                child: const Text('Create your first memory'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFeed() {
    final entries = _filteredEntries;
    if (_loading) return const Center(child: CircularProgressIndicator());

    if (_entries.isEmpty) {
      return _emptyState(
        icon: Icons.auto_stories_outlined,
        message: 'No memories yet.\nYour story starts with one tap!',
        showButton: true,
      );
    }
    if (entries.isEmpty) {
      return _emptyState(icon: Icons.search_off, message: 'No results found');
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 88),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return Dismissible(
          key: ValueKey(entry.id),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          confirmDismiss: (_) => _confirmDelete(),
          onDismissed: (_) {
            // find by id: index in the filtered list != index in _entries
            setState(() => _entries.removeWhere((e) => e.id == entry.id));
            saveEntries(_entries);
          },
          child: EntryCard(entry: entry),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memory Cards (${_entries.length})'),
        actions: [
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search memories...',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: _searchQuery.isEmpty
                    ? null
                    : IconButton(
                  tooltip: 'Clear search',
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                ),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          Expanded(child: _buildFeed()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add a new memory',
        onPressed: _openCreateScreen,
        child: const Icon(Icons.add),
      ),
    );
  }
}

