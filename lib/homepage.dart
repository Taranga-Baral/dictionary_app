import 'package:dictionary_app/models/api_models.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _wordController = TextEditingController();
  //object of class ApiModels
  ApiModels apimodels = ApiModels();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        title: Text("Words API",style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 20,
        ),),
        centerTitle: true,
        backgroundColor: Colors.lime.shade400,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                
                controller: _wordController, //Extract Text Written in Textfield
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search_sharp,color: Colors.grey,),
                    hintText: 'Enter a Word',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    )),
                onSubmitted: (value) {
                  setState(() {});
                },
              ),
            ),
            FutureBuilder(
                future: apimodels.getWordsAPI(_wordController.text),
                builder: (context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Error: ${snapshot.error}"),
                    );
                  } else if (!snapshot.hasData || snapshot.data.isEmpty) {
                    return const Center(
                      child: Text("No Data Available"),
                    );
                  } else {
                    List<dynamic> data = snapshot.data!;

                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        var wordData = data[index];
                        var word = wordData['word'];
                        var phonetic = wordData['phonetic'];
                        var meanings = wordData['meanings'];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text("Word : $word",style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                            ),
                            if (phonetic != null)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'Phonetic : $phonetic',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                      fontStyle: FontStyle.italic),
                                ),
                              ),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: meanings.length,
                              itemBuilder:
                                  (BuildContext context, int meaningIndex) {
                                var partOfSpeech =
                                    meanings[meaningIndex]['partOfSpeech'];
                                var definitions =
                                    meanings[meaningIndex]['definitions'];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 16),
                                      child: Text(
                                        '$partOfSpeech',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: definitions.length,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (BuildContext context,
                                          int definitionIndex) {
                                        var definition =
                                            definitions[definitionIndex];
                                        var definitionText =
                                            definition['definition'];
                                        var example =
                                            definition['example'] ?? '';

                                        return ListTile(
                                          title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  'Definition: $definitionText'),
                                              const Divider(
                                                thickness: 1,
                                              ),
                                              if (example.isNotEmpty)
                                                Text(
                                                  'Example : $example',
                                                  style: const TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic),
                                                ),
                                            ],
                                          ),
                                        );
                                      },
                                    )
                                  ],
                                );
                              },
                            )
                          ],
                        );
                      },
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}
