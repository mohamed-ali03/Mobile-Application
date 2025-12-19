import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseClient client = Supabase.instance.client;

  static Future<void> init() async {
    await Supabase.initialize(
      url: 'https://kqmvyaeotatuczjdokkh.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtxbXZ5YWVvdGF0dWN6amRva2toIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjYwNjQ5ODksImV4cCI6MjA4MTY0MDk4OX0.xyGTN1HXyi-QjY_QG8ldJdmG83FnwG7Es7Kx2oA9n74',
    );
  }
}
