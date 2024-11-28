export interface Database {
  public: {
    Tables: {
      users: {
        Row: {
          id: string
          email: string
          full_name: string | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          email: string
          full_name?: string | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          email?: string
          full_name?: string | null
          updated_at?: string
        }
      }
      equipment: {
        Row: {
          id: string
          user_id: string
          category_id: string | null
          name: string
          brand: string | null
          model: string | null
          serial_number: string | null
          purchase_date: string | null
          purchase_price: number | null
          condition: string | null
          notes: string | null
          last_maintenance_date: string | null
          next_maintenance_date: string | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          user_id: string
          category_id?: string | null
          name: string
          brand?: string | null
          model?: string | null
          serial_number?: string | null
          purchase_date?: string | null
          purchase_price?: number | null
          condition?: string | null
          notes?: string | null
          last_maintenance_date?: string | null
          next_maintenance_date?: string | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          user_id?: string
          category_id?: string | null
          name?: string
          brand?: string | null
          model?: string | null
          serial_number?: string | null
          purchase_date?: string | null
          purchase_price?: number | null
          condition?: string | null
          notes?: string | null
          last_maintenance_date?: string | null
          next_maintenance_date?: string | null
          updated_at?: string
        }
      }
    }
  }
}
