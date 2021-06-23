require 'rails_helper'

describe 'ユーザーログイン前のテスト' do
  describe 'トップ画面のテスト' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/'
      end
      it 'Log inリンクが表示される' do
        expect(page).to have_link"",href: new_user_session_path
      end
      it '新規登録リンクが表示される' do
        expect(page).to have_link"",href: new_user_registration_path
      end
      it 'aboutリンクが表示される' do
        expect(page).to have_link"",href: about_path
      end
      it 'タイトルの表示' do
        expect(page).to have_content 'Remount'
      end
    end
  end

  describe 'アバウト画面のテスト' do
    before do
      visit '/about'
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/about'
      end
      it 'トップ画面へのリンク' do
        expect(page).to have_link"",href: root_path
      end
    end
  end

  describe 'ヘッダーのテスト：ログイン前' do
    before do
      visit root_path
    end

    context '表示の確認' do
      it 'タイトルの表示' do
        expect(page).to have_content 'Remount'
      end
      it 'トップ画面へのリンク' do
        expect(page).to have_link('Remount')
      end
      it 'aboutリンクが表示される' do
        expect(page).to have_link('about')
      end
      it 'Log inリンクが表示される' do
        expect(page).to have_link('ログイン')
      end
      it '新規登録リンクが表示される' do
        expect(page).to have_link('新規登録')
      end
    end

    context 'リンク内容の確認' do
      subject { current_path } #テストの対象を明確にする

      it 'Remountを押すと、トップ画面に遷移する' do
        click_link 'Remount'
        is_expected.to eq '/'
      end
      it 'aboutを押すと、アバウト画面に遷移する' do
        click_link 'about'
        is_expected.to eq '/about'
      end
      it '新規登録を押すと、新規登録画面に遷移する' do
        click_link '新規登録'
        is_expected.to eq '/users/sign_up'
      end
      it 'ログインを押すと、ログイン画面に遷移する' do
        click_link 'ログイン'
        is_expected.to eq '/users/sign_in'
      end
    end
  end

  describe 'ユーザー新規登録テスト' do
    before do
      visit new_user_registration_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_up'
      end
      it '「新規登録」と表示される' do
        expect(page).to have_content '新規登録'
      end
      it 'nameフォームが表示される' do
        expect(page).to have_field 'user[name]'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'password_confirmationフォームが表示される' do
        expect(page).to have_field 'user[password_confirmation]'
      end
      it '登録ボタンが表示される' do
        expect(page).to have_button '登録'
      end
       it 'こちらへリンクが表示される' do
        expect(page).to have_link 'こちら'
       end
    end

    context 'リンク内容の確認' do
      it 'こちらを押すと、ログイン画面に遷移する' do
        click_link 'こちら'
        expect(current_path).to eq '/users/sign_in'
      end
    end

    context '新規登録成功のテスト' do
      before do
        fill_in 'user[name]',with: Faker::Lorem.characters(number: 10)
        fill_in 'user[email]', with: Faker::Internet.email
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
      end

      it '正しく新規登録される' do
        expect{ click_button '登録'}.to change(User.all, :count).by(1)
      end
      it '新規登録後のリダイレクト先がポスト一覧' do
        click_button '登録'
        expect(current_path).to eq '/posts'
      end
    end
  end

  describe 'ユーザーログイン' do
    let(:user) { create(:user)}

    before do
      visit new_user_session_path
    end

    context '表示内容の確認' do
      it 'URlが正しい' do
        expect(current_path).to eq '/users/sign_in'
      end
      it '「ログイン」と表示される' do
        expect(page).to have_content 'ログイン'
      end
      it 'nameフォームが表示される' do
        expect(page).to have_field 'user[name]'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'passwordフォームが表示さる' do
        expect(page).to have_field 'user[password]'
      end
      it 'ログインボタンが表示される' do
        expect(page).to have_button 'ログイン'
      end
      it 'こちらリンクが表示される' do
        expect(page).to have_link 'こちら'
      end
    end

    context 'リンク内容の確認' do
      it 'こちらを押すと、新規登録画面に遷移する' do
        click_link 'こちら'
        expect(current_path).to eq '/users/sign_up'
      end
    end

    context 'ログイン成功のテスト' do
      before do
        fill_in 'user[name]', with: user.name
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
      end

      it 'ログイン後のリダイレクト先が、ポスト一覧' do
        expect(current_path).to eq '/posts'
      end
    end

    context 'ログイン失敗のテスト' do
      before do
        fill_in 'user[name]', with: ''
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
        click_button 'ログイン'
      end

      it 'ログインに失敗し、ログイン画面にリダイレクトされる' do
        expect(current_path).to eq '/users/sign_in'
      end
    end
  end

  describe 'ヘッダーのテスト：ログインしている場合' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
      fill_in 'user[name]', with: user.name
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
    end

    context 'ヘッダーの表示を確認' do
      it 'タイトルが表示される' do
        expect(page).to have_content 'Remount'
      end
      it '検索ボタンが表示されている' do
        expect(page).to have_button 'Search'
      end
      it '検索フォームが表示されている' do
        expect(page).to have_field 'search'
      end
      it 'マイページボタンが表示されてい' do
        expect(page).to have_link('マイページ')
      end
      it '一覧ボタンが表示されている' do
        expect(page).to have_button('一覧')
      end
      it '投稿ボタンが表示されている' do
        expect(page).to have_button('投稿')
      end
      it 'ログアウトボタンが表示されている' do
        expect(page).to have_link('ログアウト')
      end
    end

    before do
      click_button '一覧'
    end

    context '一覧ボタンクリック後' do
      it '投稿一覧ボタンが表示される' do
        expect(page).to have_link('一覧')
      end
      it '山一覧ボタンが表示される' do
        expect(page).to have_link('山一覧')
      end
    end

    before do
      click_button '投稿'
    end

    context '投稿ボタンクリック後' do
      it '投稿ボタンが表示される' do
        expect(page).to have_link('投稿する')
      end
      it '山追加ボタンが表示される' do
        expect(page).to have_link('山追加')
      end
    end
  end

  describe 'ユーザーログアウトテスト' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
      fill_in 'user[name]', with: user.name
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
      click_link 'ログアウト'
    end

    context 'ログアウト機能のテスト' do
      it '正しくログアウトできている：ログアウト後のリダイレクト先においてabout画面へのリンク先が存在する' do
        expect(page).to have_link'',href: '/about'
      end
      it 'ログアウト後のリダイレクト先が、アバウトになっている' do
        expect(current_path).to eq '/about'
      end
    end
  end

end