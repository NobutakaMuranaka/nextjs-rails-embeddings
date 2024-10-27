'use client'

import { useState } from 'react'

type Props = {
  knowledgeUrls:
    | {
        url: string
      }[]
    | null
  fetchKnowledgeData: () => Promise<void>
}

const KnowledgeNew: React.FC<Props> = ({ knowledgeUrls, fetchKnowledgeData }) => {
  const [urls, setUrls] = useState<string[]>([])
  const [loading, setLoading] = useState(false)
  const [message, setMessage] = useState('')

  const apiUrl = process.env.NEXT_PUBLIC_RAILS_API_URL

  // POSTリクエストでデータを送信
  const onSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault()
    setLoading(true)
    setMessage('')

    try {
      const response = await fetch(`${apiUrl}/documents`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ document: { url: urls } }),
      })

      if (!response.ok) {
        throw new Error('データベースへの保存に失敗しました')
      }

      setMessage('データベースに追加されました')
      setUrls([])

      // データ追加後に最新データを取得
      await fetchKnowledgeData()
    } catch (error) {
      console.error('データ送信エラー:', error)
      setMessage('データ送信に失敗しました')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div>
      <form onSubmit={onSubmit}>
        <div className="mb-5">
          <textarea
            className="focus:outline-none p-2 w-full text-sm bg-gray-50 rounded-lg border border-gray-300 focus:ring-yellow-500 focus:border-yellow-500 focus:ring-2"
            rows={10}
            placeholder="URLを入力(複数URLは改行)"
            value={urls.join('\n')}
            onChange={(e) => setUrls(e.target.value.split('\n'))}
            disabled={loading}
          />
        </div>

        <div className="text-center my-5 font-bold text-red-500">{message}</div>

        <div className="flex justify-center mb-5">
          <button
            className="bg-yellow-400 hover:bg-yellow-500 focus:ring-4 focus:ring-yellow-300 focus:outline-none text-white font-medium rounded-lg text-sm px-5 py-3"
            type="submit"
            disabled={loading}
          >
            追加する
          </button>
        </div>

        <div>
          <div className="text-center font-bold mb-5">格納URL</div>
          {knowledgeUrls && knowledgeUrls.length ? (
            <div className="border rounded">
              {knowledgeUrls.map((data, index) => (
                <a href={data.url} key={index} target="_blank" rel="noopener noreferrer">
                  <div
                    className={`${
                      knowledgeUrls.length - 1 !== index && 'border-b'
                    } p-2 text-blue-500 underline hover:bg-gray-100`}
                  >
                    {data.url}
                  </div>
                </a>
              ))}
            </div>
          ) : (
            <div className="text-center">知識データベースがありません</div>
          )}
        </div>
      </form>
    </div>
  )
}

export default KnowledgeNew
