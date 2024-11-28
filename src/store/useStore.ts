import { create } from 'zustand'
import { supabase } from '@/lib/supabase'

interface Equipment {
  id: string
  name: string
  brand: string | null
  model: string | null
  serial_number: string | null
  condition: string | null
  purchase_date: string | null
  purchase_price: number | null
  notes: string | null
  category_id: string | null
}

interface Store {
  equipment: Equipment[]
  loading: boolean
  error: string | null
  fetchEquipment: () => Promise<void>
}

export const useStore = create<Store>((set) => ({
  equipment: [],
  loading: false,
  error: null,
  fetchEquipment: async () => {
    set({ loading: true, error: null })
    try {
      console.log('Fetching equipment from Supabase...')
      const { data, error } = await supabase
        .from('equipment')
        .select('*')
      
      if (error) throw error
      
      console.log('Fetched equipment:', data)
      set({ equipment: data || [] })
    } catch (error) {
      console.error('Error fetching equipment:', error)
      set({ error: 'Failed to fetch equipment' })
      set({ equipment: [] })
    } finally {
      set({ loading: false })
    }
  }
}))
