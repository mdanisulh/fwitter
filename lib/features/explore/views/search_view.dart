import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fwitter/common/common.dart';
import 'package:fwitter/features/explore/controller/explore_controller.dart';
import 'package:fwitter/features/explore/widgets/search_tile.dart';
import 'package:fwitter/theme/theme.dart';

class SearchView extends ConsumerStatefulWidget {
  const SearchView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchViewState();
}

class _SearchViewState extends ConsumerState<SearchView> {
  final searchTextController = TextEditingController();
  bool isSearching = false;

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchTextController,
          autofocus: true,
          onSubmitted: (value) => setState(() {
            isSearching = searchTextController.text.isNotEmpty;
          }),
          onChanged: (value) => setState(() {
            isSearching = false;
          }),
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            hintText: 'Search',
            hintStyle: const TextStyle(fontSize: 16),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: Pallete.blue,
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: Pallete.grey,
                width: 2,
              ),
            ),
            focusColor: Pallete.blue,
            contentPadding: const EdgeInsets.all(15).copyWith(left: 25),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  if (isSearching) {
                    searchTextController.clear();
                    isSearching = false;
                  } else {
                    isSearching = searchTextController.text.isNotEmpty;
                  }
                });
              },
              padding: const EdgeInsets.only(right: 20),
              icon: isSearching ? const Icon(Icons.clear, color: Pallete.grey) : const Icon(Icons.search, color: Pallete.grey),
            ),
          ),
        ),
      ),
      body: !isSearching
          ? const SizedBox()
          : ref.watch(searchUsersProvider(searchTextController.text)).when(
                data: (users) {
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return SearchTile(user: user);
                    },
                  );
                },
                error: (error, stackTrace) => ErrorPage(error: error.toString()),
                loading: () => const Loader(),
              ),
    );
  }
}
