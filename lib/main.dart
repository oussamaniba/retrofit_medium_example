import 'package:flutter/material.dart';
import 'package:retrofit_example/api/api_service.dart';
import 'package:retrofit_example/data/posts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final apiService = ApiService.instance.restClient;

  Posts? posts;
  TextEditingController controller = TextEditingController();

  Future getPost(String id) async {
    var v = await apiService.getPostWithPath(id.toString());
    setState(() {
      posts = v;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: "Type the id of the post",
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  await getPost(controller.text);
                },
                child: const Text(
                  "Search",
                ),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<Posts?>(
              future: Future.value(posts),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.black),
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text("No Data!"));
                } else {
                  return Center(
                    child: PostItem(
                      post: snapshot.data!,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PostItem extends StatelessWidget {
  final Posts post;
  const PostItem({
    required this.post,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post.title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            post.body,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
