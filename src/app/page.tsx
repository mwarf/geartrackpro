import Link from 'next/link'
import { Camera, Package, Calendar, Settings } from 'lucide-react'

export default function Home() {
  return (
    <div className="container mx-auto px-4 py-8">
      <h1 className="text-4xl font-bold mb-8">Gear Manager</h1>
      
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <DashboardCard
          icon={<Camera className="w-6 h-6" />}
          title="Equipment"
          description="Manage your gear inventory"
          href="/equipment"
        />
        <DashboardCard
          icon={<Package className="w-6 h-6" />}
          title="Cases"
          description="Organize your equipment cases"
          href="/cases"
        />
        <DashboardCard
          icon={<Calendar className="w-6 h-6" />}
          title="Maintenance"
          description="Track maintenance schedules"
          href="/maintenance"
        />
        <DashboardCard
          icon={<Settings className="w-6 h-6" />}
          title="Settings"
          description="Configure your account"
          href="/settings"
        />
      </div>
    </div>
  )
}

function DashboardCard({ icon, title, description, href }: {
  icon: React.ReactNode
  title: string
  description: string
  href: string
}) {
  return (
    <Link
      href={href}
      className="block p-6 bg-white rounded-lg shadow-sm hover:shadow-md transition-shadow"
    >
      <div className="flex items-center mb-4">
        <div className="p-2 bg-blue-100 rounded-lg">
          {icon}
        </div>
      </div>
      <h2 className="text-xl font-semibold mb-2">{title}</h2>
      <p className="text-gray-600">{description}</p>
    </Link>
  )
}
