import 'package:eng_std/databaseConfig.dart';

import 'package:flutter/material.dart';

import 'word.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Flutter App', home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _meaningController = TextEditingController();

  final DatabaseService _databaseService = DatabaseService();

  Future<List<Word>> _wordList = DatabaseService()
      .databaseConfig()
      .then((_) => DatabaseService().selectWords());

  int currentCount = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SQLITE'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => addWordDialog(),
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder(
          future: _wordList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              currentCount = snapshot.data!.length;

              if (currentCount == 0) {
                return const Center(
                  child: Text("No data exists."),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return wordBox(
                        snapshot.data![index].id,
                        snapshot.data![index].name,
                        snapshot.data![index].meaning);
                  },
                );
              }
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("Error."),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget wordBox(int id, String name, String meaning) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          child: Text("$id"),
        ),
        Container(
          padding: const EdgeInsets.all(15),
          child: Text(name),
        ),
        Container(
          padding: const EdgeInsets.all(15),
          child: Text(meaning),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              updateButton(id),
              const SizedBox(width: 10),
              deleteButton(id),
            ],
          ),
        ),
      ],
    );
  }

  Widget updateButton(int id) {
    return ElevatedButton(
        onPressed: () {
          Future<Word> word = _databaseService.selectWord(id);

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => updateWordDialog(word),
          );
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.green),
        ),
        child: const Icon(Icons.edit));
  }

  Widget deleteButton(int id) {
    return ElevatedButton(
        onPressed: () => showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => deleteWordDialog(id),
            ),
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.red),
        ),
        child: const Icon(Icons.delete));
  }

  Widget addWordDialog() {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("단어 추가"),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.close,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(hintText: "단어를 입력하세요.,"),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _meaningController,
            decoration: const InputDecoration(
              hintText: "뜻을 입력하세요.",
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              _databaseService
                  .insertWord(Word(
                      id: currentCount + 1,
                      name: _nameController.text,
                      meaning: _meaningController.text))
                  .then(
                (result) {
                  if (result) {
                    Navigator.of(context).pop();

                    setState(() {
                      _wordList = _databaseService.selectWords();
                    });
                  } else {
                    print("insert error");
                  }
                },
              );
            },
            child: const Text("생성"),
          ),
        ],
      ),
    );
  }

  Widget updateWordDialog(Future<Word> word) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("단어 수정"),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.close,
            ),
          ),
        ],
      ),
      content: FutureBuilder(
          future: word,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _nameController.text = snapshot.data!.name;

              _meaningController.text = snapshot.data!.meaning;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(hintText: "단어를 입력하세요."),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _meaningController,
                    decoration: const InputDecoration(
                      hintText: "뜻을 입력하세요.",
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      _databaseService
                          .updateWord(Word(
                              id: snapshot.data!.id,
                              name: _nameController.text,
                              meaning: _meaningController.text))
                          .then(
                        (result) {
                          if (result) {
                            Navigator.of(context).pop();

                            setState(() {
                              _wordList = _databaseService.selectWords();
                            });
                          } else {
                            print("update error");
                          }
                        },
                      );
                    },
                    child: const Text("수정"),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("Error occurred!"),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              );
            }
          }),
    );
  }

  Widget deleteWordDialog(int id) {
    return AlertDialog(
      title: const Text("이 단어를 삭제하시겠습니까?"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  _databaseService.deleteWord(id).then(
                    (result) {
                      if (result) {
                        Navigator.of(context).pop();

                        setState(() {
                          _wordList = _databaseService.selectWords();
                        });
                      } else {
                        print("delete error");
                      }
                    },
                  );
                },
                child: const Text("예"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("아니오"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
