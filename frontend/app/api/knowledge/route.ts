import { NextRequest, NextResponse } from 'next/server';

export async function POST(req: NextRequest) {
  const { urls } = await req.json();

  try {
    const response = await fetch('http://localhost:3000/documents', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ urls }),
    });

    if (!response.ok) {
      return NextResponse.json({ error: 'サーバー側のエラーが発生しました' }, { status: 500 });
    }

    return NextResponse.json({ success: true }, { status: 200 });
  } catch (err) {
    console.error(err);
    return NextResponse.json({ error: 'ネットワークエラーが発生しました' }, { status: 500 });
  }
}
