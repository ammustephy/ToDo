class SupabaseConfig {
  static const String supabaseUrl = String.fromEnvironment(
    'https://isnjapvihhnyfjvllotk.supabase.co',
    defaultValue: 'https://isnjapvihhnyfjvllotk.supabase.co',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlzbmphcHZpaGhueWZqdmxsb3RrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjExNDM4NzAsImV4cCI6MjA3NjcxOTg3MH0._whFETIySpvaO2ZA28uXL9kVc06uST7mZkvnj5RPl1Y',
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlzbmphcHZpaGhueWZqdmxsb3RrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjExNDM4NzAsImV4cCI6MjA3NjcxOTg3MH0._whFETIySpvaO2ZA28uXL9kVc06uST7mZkvnj5RPl1Y',
  );
}