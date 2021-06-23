require 'rails_helper'

describe 'ユーザーログイン後のテスト（２）' do
  let(:user) {create(:user) }
  let!(:other_user) {create(:user) }
  let!(:post) {create(:post, user: user)}
  let!(:other_post) { create(:post, user: other_user) }
  let!(:mountain) { create(:mountain, user: user) }

  before do
    visit new_user_session_path
    fill_in 'user[name]',with: user.name
    fill_in 'user[email]',with: user.email
    fill_in 'user[password]',with: user.password
    click_button 'ログイン'
  end

  describe 'ヘッダーのテスト：ログインしている場合' do
    context 'リンク内容の確認' do
      subject { current_path }

      it 'マイページを押すと、自分のユーザー詳細画面に遷移する' do
        click_link 'マイページ'
        is_expected.to eq '/users/' + user.id.to_s
      end

      before do
        click_button '一覧'
      end
      it '投稿一覧を押すと、投稿一覧画面に遷移する' do
        click_link '投稿一覧'
        is_expected.to eq '/posts'
      end
      it '山一覧を押すと、山一覧画面に遷移する' do
        click_link '山一覧'
        is_expected.to eq '/mountains'
      end

      before do
        click_button '投稿'
      end
      it '投稿するを押すと、投稿画面に遷移する' do
        click_link '投稿する'
        is_expected.to eq '/posts/new'
      end
      it '山追加を押すと、山追加画面に遷移する' do
        click_link '山追加'
        is_expected.to eq '/mountains/new'
      end
    end
  end

  describe '投稿一覧画面のテスト' do
    before do
      visit posts_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts'
      end
      it '自分と他人の画像のリンク先が正しい' do
        expect(page).to have_link '', href: post_path(post.user)
        expect(page).to have_link '', href: post_path(other_post.user)
      end
      it '自分の投稿と他人の名前が表示される' do
        expect(page).to have_content user.name
        expect(page).to have_content other_user.name
      end
      it '自分の投稿と他人の投稿のタイトルが表示される' do
        expect(page).to have_content post.title
        expect(page).to have_content other_post.title
      end
      it '自分の投稿と他人の投稿内容が表示される' do
        expect(page).to have_content post.body
        expect(page).to have_content other_post.body
      end
      it 'いいねアイコンが表示される' do
        expect(page).to have_selector '.fas.fa-heart'
      end
      it 'コメントアイコンが表示される' do
        expect(page).to have_selector '.far.fa-comment'
      end
    end
  end

  describe '投稿画面のテスト' do
    before do
      visit new_post_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
       expect(current_path).to eq '/posts/new'
      end
      it '新規登録の文字が表示される' do
        expect(page).to have_content '新規登録'
      end
      it 'タイトルフォームが表示される' do
        expect(page).to have_field 'post[title]'
      end
      it '投稿内容フォームが表示される' do
        expect(page).to have_field 'post[body]'
      end
      it 'タグ投稿フォームが表示される' do
        expect(page).to have_field 'post[tag_names]'
      end
      it '画像投稿フォームが表示される' do
        expect(page).to have_field 'post[image]'
      end
      it '投稿ボタンが表示される' do
        expect(page).to have_button '新規登録'
      end
    end

    context '投稿成功のテスト' do
      before do
        fill_in 'post[title]', with: Faker::Lorem.characters(number: 5)
        fill_in 'post[body]', with: Faker::Lorem.characters(number: 20)
        image_path = Rails.root.join('spec/fixtures/no_image.jpg')
        attach_file('post[image]', image_path)
      end

      it '自分の新しい投稿が正しく保存される' do
        expect { click_button '新規登録' }.to change(user.posts, :count).by(1)
      end
      it 'リダイレクト先が、保存できた投稿の詳細画面になっている' do
        click_button '新規登録'
        expect(current_path).to eq '/posts/' + Post.last.id.to_s
      end
    end
  end

  describe '自分の投稿詳細画面のテスト' do
    before do
      visit post_path(post)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts/' + post.id.to_s
      end
      it 'ユーザー詳細へのリンクが表示される' do
        expect(page).to have_link user.name,href: user_path(user)
      end
      it '自分の名前が表示される' do
        expect(page).to have_content user.name
      end
      it '自分の投稿のタイトルが表示される' do
        expect(page).to have_content post.title
      end
      it '自分の投稿内容が表示される' do
        expect(page).to have_content post.body
      end
      it 'いいねアイコンが表示される' do
        expect(page).to have_selector '.fas.fa-heart'
      end
      it 'コメントアイコンが表示される' do
        expect(page).to have_selector '.far.fa-comment'
      end
      it '投稿の編集リンクが表示される' do
        expect(page).to have_link '編集', href: edit_post_path(post)
      end
      it '投稿の削除リンクが表示される' do
        expect(page).to have_link '削除', href: post_path(post)
      end
      it 'コメントフォームが表示される' do
        expect(page).to have_field 'comment[comment]'
      end
      it 'コメント投稿ボタンが表示される' do
        expect(page).to have_button 'コメントする'
      end
    end
  end

  describe '投稿編集画面のテスト' do
    before do
      visit edit_post_path(post)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts/' + post.id.to_s + '/edit'
      end
      it 'タイトルフォームにタイトルが表示される' do
        expect(page).to have_field 'post[title]',with: post.title
      end
      it '投稿内容フォームに表示される' do
        expect(page).to have_field 'post[body]',with: post.body
      end
      it 'タグ投稿フォームが表示される' do
        expect(page).to have_field 'post[tag_names]'
      end
      it '画像投稿フォームが表示される' do
        expect(page).to have_field 'post[image]'
      end
      it '更新ボタンが表示される' do
        expect(page).to have_button '変更を保存'
      end
    end

    context '更新のテスト' do
      before do
        @post_old_title = post.title
        @post_old_body = post.body
        fill_in 'post[title]', with: Faker::Lorem.characters(number: 9)
        fill_in 'post[body]', with: Faker::Lorem.characters(number: 19)
        click_button '変更を保存'
      end
      it 'titleが正しく更新される' do
        expect(post.reload.title).not_to eq @post_old_title
      end
      it 'introductionが正しく更新される' do
        expect(post.reload.body).not_to eq @post_old_body
      end
      it 'リダイレクト先が、投稿詳細画面になっている' do
        expect(current_path).to eq '/posts/' + post.id.to_s
      end
    end
  end

  describe '自分のユーザ詳細画面のテスト' do
    before do
      visit user_path(user)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
      it '名前が表示される' do
        expect(page).to have_content user.name
      end
      it '投稿数が表示される' do
        expect(page).to have_content user.posts.count
      end
      it 'フォローリンクが表示される' do
        expect(page).to have_link '',href: user_followings_path(user)
      end
      it 'フォロワーリンクが表示される' do
        expect(page).to have_link '',href: user_followers_path(user)
      end
      it '編集リンクが表示される' do
        expect(page).to have_link '',href: edit_user_path(user)
      end
    end
  end

  describe '自分のユーザー情報編集画面のテスト' do
    before do
      visit edit_user_path(user)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s + '/edit'
      end
      it '名前編集フォームに自分の名前が表示される' do
        expect(page).to have_field 'user[name]',with: user.name
      end
      it '画像編集フォームが表示される' do
        expect(page).to have_field 'user[profile_image]'
      end
      it '自己紹介編集フォームに自分の紹介文が表示される' do
        expect(page).to have_field 'user[introduction]',with: user.introduction
      end
      it '更新ボタンが表示される' do
        expect(page).to have_button '更新'
      end
      it '退会ボタンが表示される' do
        expect(page).to have_link '退会する'
      end
    end

    context '更新のテスト' do
      before do
        @user_old_name = user.name
        @user_old_introduction = user.introduction
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 9)
        fill_in 'user[introduction]', with: Faker::Lorem.characters(number: 19)
        click_button '更新'
      end

      it 'nameが正しく更新される' do
        expect(user.reload.name).not_to eq @user_old_name
      end
      it 'introductionが正しく更新される' do
        expect(user.reload.introduction).not_to eq @user_old_intrpduction
      end
      it 'リダイレクト先が、自分のユーザ詳細画面になっている' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
    end
  end

  describe '山投稿画面のテスト' do
    before do
      visit new_mountain_path
    end

    context '表示テスト' do
      it 'URLが正しい' do
        expect(current_path).to eq '/mountains/new'
      end
      it '名前編集フォームが表示される'do
        expect(page).to have_field 'mountain[mountain_name]'
      end
      it '山詳細フォームが表示される' do
        expect(page).to have_field 'mountain[mountain_body]'
      end
      it '住所投稿フォームが表示される'do
        expect(page).to have_field 'mountain[address]'
      end
      it '画像フォームが表示される' do
        expect(page).to have_field 'mountain[mountain_image]'
      end
      it '新規登録ボタンが表示される' do
        expect(page).to have_button '新規登録'
      end
    end

    context '投稿成功のテスト' do
      before do
        fill_in 'mountain[mountain_name]', with: Faker::Lorem.characters(number: 5)
        fill_in 'mountain[mountain_body]', with: Faker::Lorem.characters(number: 20)
        fill_in 'mountain[address]', with: Faker::Address.name
        image_path = Rails.root.join('spec/fixtures/no_image.jpg')
        attach_file('mountain[mountain_image]', image_path)
      end


      it '新しい投稿が正しく保存される' do
        expect { click_button '新規登録' }.to change{Mountain.count}.by(1)
      end
      it 'リダイレクト先が、保存できた投稿の詳細画面になっている' do
        click_button '新規登録'
        expect(current_path).to eq '/mountains/' + Mountain.last.id.to_s
      end
    end
  end

  describe '山一覧画面のテスト' do
    before do
      visit mountains_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/mountains'
      end
      it '画像のリンクが正しい' do
        expect(page).to have_link '', href: '/mountains/' + mountain.id.to_s
      end
      it '投稿者名が表示される' do
        expect(page).to have_content mountain.user.name
      end
      it '山の名前が表示される' do
        expect(page).to have_content mountain.mountain_name
      end
      it '山の詳細が表示される' do
        expect(page).to have_content mountain.mountain_body
      end
    end
  end

  describe '山詳細画面テスト' do
    before do
      visit mountain_path(mountain)
    end

    context '表示テスト' do
      it 'URLが正しい' do
        expect(current_path).to eq '/mountains/' + mountain.id.to_s
      end
      it '投稿者名が表示される' do
        expect(page).to have_content mountain.user.name
      end
      it '山の名前が表示される' do
        expect(page).to have_content mountain.mountain_name
      end
      it '山の詳細が表示される' do
        expect(page).to have_content mountain.mountain_body
      end
      it '住所が表示される' do
        expect(page).to have_content mountain.address
      end
      it 'mapが表示される' do
        expect(page).to have_css('div#map')
      end
      it '投稿の編集リンクが表示される' do
       expect(page).to have_link '編集', href: edit_mountain_path(mountain)
      end
      it '投稿の削除リンクが表示される' do
        expect(page).to have_link '削除', href: mountain_path(mountain)
      end
    end
  end

  describe '山編集画面のテスト'do
    before do
      visit edit_mountain_path(mountain)
    end

    context '表示テスト' do
      it 'URLが正しい' do
        expect(current_path).to eq '/mountains/' + mountain.id.to_s + '/edit'
      end
      it '名前編集フォームで名前が表示される'do
        expect(page).to have_field 'mountain[mountain_name]',with: mountain.mountain_name
      end
      it '山詳細フォームで詳細が表示される' do
        expect(page).to have_field 'mountain[mountain_body]',with: mountain.mountain_body
      end
      it '画像編集フォームが表示される' do
        expect(page).to have_field 'mountain[mountain_image]'
      end
      it '変更保存ボタンが表示される' do
        expect(page).to have_button '変更を保存'
      end
    end

    context '更新のテスト' do
      before do
        @mountain_old_name = mountain.mountain_name
        @mountain_old_body = mountain.mountain_body
        @mountain_old_address = mountain.address
        fill_in 'mountain[mountain_name]', with: Faker::Lorem.characters(number: 9)
        fill_in 'mountain[mountain_body]', with: Faker::Lorem.characters(number: 19)
        fill_in 'mountain[address]', with: Faker::Lorem.characters(number: 2)
        click_button '変更を保存'
      end

      it '名前が正しく更新される' do
        expect(mountain.reload.mountain_name).not_to eq @mountain_old_name
      end
      it '詳細が正しく更新される' do
        expect(mountain.reload.mountain_body).not_to eq @mountain_old_body
      end
      it '住所が正しく更新される' do
        expect(mountain.reload.address).not_to eq @mountain_old_address
      end
      it 'リダイレクト先が、詳細画面になっている' do
        expect(current_path).to eq '/mountains/' + mountain.id.to_s
      end
    end
  end
end