defmodule KyozoStore.OrgTest do
  use KyozoStore.DataCase

  alias KyozoStore.Org

  describe "user" do
    alias KyozoStore.Org.User

    @valid_attrs %{avatar_url: "some avatar_url", boxes: [], profile_html: "some profile_html", profile_markdown: "some profile_markdown", username: "some username"}
    @update_attrs %{avatar_url: "some updated avatar_url", boxes: [], profile_html: "some updated profile_html", profile_markdown: "some updated profile_markdown", username: "some updated username"}
    @invalid_attrs %{avatar_url: nil, boxes: nil, profile_html: nil, profile_markdown: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Org.create_user()

      user
    end

    test "list_user/0 returns all user" do
      user = user_fixture()
      assert Org.list_user() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Org.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Org.create_user(@valid_attrs)
      assert user.avatar_url == "some avatar_url"
      assert user.boxes == []
      assert user.profile_html == "some profile_html"
      assert user.profile_markdown == "some profile_markdown"
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Org.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Org.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.avatar_url == "some updated avatar_url"
      assert user.boxes == []
      assert user.profile_html == "some updated profile_html"
      assert user.profile_markdown == "some updated profile_markdown"
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Org.update_user(user, @invalid_attrs)
      assert user == Org.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Org.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Org.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Org.change_user(user)
    end
  end

  describe "box" do
    alias KyozoStore.Org.User.Box

    @valid_attrs %{current_version: %{}, description_html: "some description_html", description_markdown: "some description_markdown", name: "some name", private: true, short_description: "some short_description", tag: "some tag", username: "some username", versions: []}
    @update_attrs %{current_version: %{}, description_html: "some updated description_html", description_markdown: "some updated description_markdown", name: "some updated name", private: false, short_description: "some updated short_description", tag: "some updated tag", username: "some updated username", versions: []}
    @invalid_attrs %{current_version: nil, description_html: nil, description_markdown: nil, name: nil, private: nil, short_description: nil, tag: nil, username: nil, versions: nil}

    def box_fixture(attrs \\ %{}) do
      {:ok, box} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Org.create_box()

      box
    end

    test "list_box/0 returns all box" do
      box = box_fixture()
      assert Org.list_box() == [box]
    end

    test "get_box!/1 returns the box with given id" do
      box = box_fixture()
      assert Org.get_box!(box.id) == box
    end

    test "create_box/1 with valid data creates a box" do
      assert {:ok, %Box{} = box} = Org.create_box(@valid_attrs)
      assert box.current_version == %{}
      assert box.description_html == "some description_html"
      assert box.description_markdown == "some description_markdown"
      assert box.name == "some name"
      assert box.private == true
      assert box.short_description == "some short_description"
      assert box.tag == "some tag"
      assert box.username == "some username"
      assert box.versions == []
    end

    test "create_box/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Org.create_box(@invalid_attrs)
    end

    test "update_box/2 with valid data updates the box" do
      box = box_fixture()
      assert {:ok, box} = Org.update_box(box, @update_attrs)
      assert %Box{} = box
      assert box.current_version == %{}
      assert box.description_html == "some updated description_html"
      assert box.description_markdown == "some updated description_markdown"
      assert box.name == "some updated name"
      assert box.private == false
      assert box.short_description == "some updated short_description"
      assert box.tag == "some updated tag"
      assert box.username == "some updated username"
      assert box.versions == []
    end

    test "update_box/2 with invalid data returns error changeset" do
      box = box_fixture()
      assert {:error, %Ecto.Changeset{}} = Org.update_box(box, @invalid_attrs)
      assert box == Org.get_box!(box.id)
    end

    test "delete_box/1 deletes the box" do
      box = box_fixture()
      assert {:ok, %Box{}} = Org.delete_box(box)
      assert_raise Ecto.NoResultsError, fn -> Org.get_box!(box.id) end
    end

    test "change_box/1 returns a box changeset" do
      box = box_fixture()
      assert %Ecto.Changeset{} = Org.change_box(box)
    end
  end

  describe "version" do
    alias KyozoStore.Org.User.Box.Version

    @valid_attrs %{description_html: "some description_html", description_markdown: "some description_markdown", number: "some number", providers: [], release_url: "some release_url", revoke_url: "some revoke_url", status: "some status", version: "some version"}
    @update_attrs %{description_html: "some updated description_html", description_markdown: "some updated description_markdown", number: "some updated number", providers: [], release_url: "some updated release_url", revoke_url: "some updated revoke_url", status: "some updated status", version: "some updated version"}
    @invalid_attrs %{description_html: nil, description_markdown: nil, number: nil, providers: nil, release_url: nil, revoke_url: nil, status: nil, version: nil}

    def version_fixture(attrs \\ %{}) do
      {:ok, version} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Org.create_version()

      version
    end

    test "list_version/0 returns all version" do
      version = version_fixture()
      assert Org.list_version() == [version]
    end

    test "get_version!/1 returns the version with given id" do
      version = version_fixture()
      assert Org.get_version!(version.id) == version
    end

    test "create_version/1 with valid data creates a version" do
      assert {:ok, %Version{} = version} = Org.create_version(@valid_attrs)
      assert version.description_html == "some description_html"
      assert version.description_markdown == "some description_markdown"
      assert version.number == "some number"
      assert version.providers == []
      assert version.release_url == "some release_url"
      assert version.revoke_url == "some revoke_url"
      assert version.status == "some status"
      assert version.version == "some version"
    end

    test "create_version/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Org.create_version(@invalid_attrs)
    end

    test "update_version/2 with valid data updates the version" do
      version = version_fixture()
      assert {:ok, version} = Org.update_version(version, @update_attrs)
      assert %Version{} = version
      assert version.description_html == "some updated description_html"
      assert version.description_markdown == "some updated description_markdown"
      assert version.number == "some updated number"
      assert version.providers == []
      assert version.release_url == "some updated release_url"
      assert version.revoke_url == "some updated revoke_url"
      assert version.status == "some updated status"
      assert version.version == "some updated version"
    end

    test "update_version/2 with invalid data returns error changeset" do
      version = version_fixture()
      assert {:error, %Ecto.Changeset{}} = Org.update_version(version, @invalid_attrs)
      assert version == Org.get_version!(version.id)
    end

    test "delete_version/1 deletes the version" do
      version = version_fixture()
      assert {:ok, %Version{}} = Org.delete_version(version)
      assert_raise Ecto.NoResultsError, fn -> Org.get_version!(version.id) end
    end

    test "change_version/1 returns a version changeset" do
      version = version_fixture()
      assert %Ecto.Changeset{} = Org.change_version(version)
    end
  end

  describe "provider" do
    alias KyozoStore.Org.User.Box.Version.Provider

    @valid_attrs %{download_url: "some download_url", hosted: true, hosted_token: "some hosted_token", name: "some name", original_url: "some original_url"}
    @update_attrs %{download_url: "some updated download_url", hosted: false, hosted_token: "some updated hosted_token", name: "some updated name", original_url: "some updated original_url"}
    @invalid_attrs %{download_url: nil, hosted: nil, hosted_token: nil, name: nil, original_url: nil}

    def provider_fixture(attrs \\ %{}) do
      {:ok, provider} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Org.create_provider()

      provider
    end

    test "list_provider/0 returns all provider" do
      provider = provider_fixture()
      assert Org.list_provider() == [provider]
    end

    test "get_provider!/1 returns the provider with given id" do
      provider = provider_fixture()
      assert Org.get_provider!(provider.id) == provider
    end

    test "create_provider/1 with valid data creates a provider" do
      assert {:ok, %Provider{} = provider} = Org.create_provider(@valid_attrs)
      assert provider.download_url == "some download_url"
      assert provider.hosted == true
      assert provider.hosted_token == "some hosted_token"
      assert provider.name == "some name"
      assert provider.original_url == "some original_url"
    end

    test "create_provider/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Org.create_provider(@invalid_attrs)
    end

    test "update_provider/2 with valid data updates the provider" do
      provider = provider_fixture()
      assert {:ok, provider} = Org.update_provider(provider, @update_attrs)
      assert %Provider{} = provider
      assert provider.download_url == "some updated download_url"
      assert provider.hosted == false
      assert provider.hosted_token == "some updated hosted_token"
      assert provider.name == "some updated name"
      assert provider.original_url == "some updated original_url"
    end

    test "update_provider/2 with invalid data returns error changeset" do
      provider = provider_fixture()
      assert {:error, %Ecto.Changeset{}} = Org.update_provider(provider, @invalid_attrs)
      assert provider == Org.get_provider!(provider.id)
    end

    test "delete_provider/1 deletes the provider" do
      provider = provider_fixture()
      assert {:ok, %Provider{}} = Org.delete_provider(provider)
      assert_raise Ecto.NoResultsError, fn -> Org.get_provider!(provider.id) end
    end

    test "change_provider/1 returns a provider changeset" do
      provider = provider_fixture()
      assert %Ecto.Changeset{} = Org.change_provider(provider)
    end
  end
end
