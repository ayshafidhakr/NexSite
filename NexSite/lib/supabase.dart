import 'package:supabase_flutter/supabase_flutter.dart';

// Replace these with your actual Supabase project credentials
const String supabaseUrl = 'https://vkcerptcmlliukmdlbrp.supabase.co';
const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZrY2VycHRjbWxsaXVrbWRsYnJwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ0NTkyMTYsImV4cCI6MjA3MDAzNTIxNn0.5298ibmKuopAEuwHUce2kl-5gDNdXQzJUbd136EWTR8';

class SupabaseService {
  static final SupabaseClient client = Supabase.instance.client;
}

Future<void> initializeSupabase() async {
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );
}
