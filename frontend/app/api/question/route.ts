import { NextRequest, NextResponse } from 'next/server';

export async function POST(req: NextRequest) {
  const { question } = await req.json();

  // 質問が送信されていない場合のエラーハンドリング
  if (!question) {
    return NextResponse.json({ error: '質問がありません' }, { status: 400 });
  }

  // 仮の回答を返す
  const answer = `質問: ${question} に対する仮の回答`;

  return NextResponse.json({ answer }, { status: 200 });
}
