import Foundation
import Supabase

class SupabaseManager {
    static let shared = SupabaseManager()

    private var client: SupabaseClient

    private init() {
        let supabaseUrl = URL(string: "https://jfpseiedglkbobktcrxw.supabase.co")!
        let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpmcHNlaWVkZ2xrYm9ia3Rjcnh3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjcyODIyMzAsImV4cCI6MjA0Mjg1ODIzMH0.Ysb3MZP8-v3V2rnkuoxNKxLQAKBhb0IalSv92q_pZjE"
        
        client = SupabaseClient(supabaseURL: supabaseUrl, supabaseKey: supabaseKey)
    }
    
    func getClient() -> SupabaseClient {
        return client
    }
}
