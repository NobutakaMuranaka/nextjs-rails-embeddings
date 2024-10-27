'use client'

import { useEffect, useState } from 'react'
import KnowledgeNew from '../components/knowledge/knowledge-new'

type UrlType = {
  url: string
}[]

const apiUrl = process.env.NEXT_PUBLIC_RAILS_API_URL

const Knowledge = () => {
  const [knowledgeUrls, setKnowledgeUrls] = useState<UrlType | null>(null)

  // GETリクエストでデータを取得
  const fetchKnowledgeData = async () => {
    try {
      const response = await fetch(`${apiUrl}/documents`, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
        },
      })

      if (!response.ok) {
        throw new Error('データベースの取得に失敗しました')
      }

      const data: UrlType = await response.json()
      setKnowledgeUrls(data)
    } catch (error) {
      console.error('データ取得エラー:', error)
    }
  }

  // 初回レンダリング時にデータを取得
  useEffect(() => {
    fetchKnowledgeData()
  }, [])

  return (
    <div className="p-5">
      <div className="mb-3 text-center text-xl font-bold">知識データベース</div>
      <div className="mb-5 text-center">指定したURLの文章を知識データベースに追加します</div>
      <KnowledgeNew knowledgeUrls={knowledgeUrls} fetchKnowledgeData={fetchKnowledgeData} />
    </div>
  )
}

export default Knowledge
