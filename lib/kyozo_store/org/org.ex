defmodule KyozoStore.Org do
  @moduledoc """
  The Org context.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias KyozoStore.Repo
  alias KyozoStore.Org.User
  alias KyozoStore.Org.User.Box
  alias KyozoStore.Org.User.Box.Version
  alias KyozoStore.Org.User.Box.Version.Provider


  @doc """
  Returns the list of user.

  ## Examples

      iex> list_user()
      [%User{}, ...]

  """
  def list_user do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(username) do
    Repo.get(User, username)
    |> Repo.preload([:boxes])
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> user_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> user_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    user_changeset(user, %{})
  end

  @doc false
  defp user_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:username, :email, :avatar_url, :profile_html, :profile_markdown])
    |> cast_assoc(:user_auth)
    |> cast_assoc(:boxes, with: &User.Box.changeset/2)
    |> validate_required([:username, :email])
    |> unique_constraint(:username)
  end

  alias KyozoStore.Org.UserAuth

    @doc """
  Returns the list of user.

  ## Examples

      iex> list_user()
      [%User{}, ...]

  """
  def list_userauth do
    Repo.all(UserAuth)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_userauth!(keycloak_id) do
    Repo.get(UserAuth, keycloak_id)
  end

  @doc """
  Creates a user auth.

  ## Examples

      iex> create_userauth(%{field: value})
      {:ok, %User{}}

      iex> create_userauth(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_userauth(attrs \\ %{}) do
    %UserAuth{}
    |> userauth_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_userauth(%UserAuth{} = user_auth, attrs) do
    user_auth
    |> userauth_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_userauth(%UserAuth{} = user_auth) do
    Repo.delete(user_auth)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_userauth(%UserAuth{} = user_auth) do
    userauth_changeset(user_auth, %{})
  end

  @doc false
  def userauth_changeset(%UserAuth{} = user_auth, attrs) do
    user_auth
    |> cast(attrs, [:method, :remote_id, :keycloak_id, :username])
    |> validate_required([:method, :remote_id, :keycloak_id])
    |> assoc_constraint(:user)
  end


  @doc """
  Returns the list of box.

  ## Examples

      iex> list_box()
      [%Box{}, ...]

  """
  def list_box(username) do
    from(
      b in Box,
      where: b.username == ^username
    )
    |> Repo.all()
  end

  @doc """
  Gets a single box.

  Raises `Ecto.NoResultsError` if the Box does not exist.

  ## Examples

      iex> get_box!(123)
      %Box{}

      iex> get_box!(456)
      ** (Ecto.NoResultsError)

  """
  def get_box!(username, name) do
    Repo.get_by(Box, [username: username, name: name])
  end

  @doc """
  Creates a box.

  ## Examples

      iex> create_box(%{field: value})
      {:ok, %Box{}}

      iex> create_box(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_box(attrs \\ %{}) do
    %Box{}
    |> User.Box.changeset(attrs)
    |> Repo.insert()
  end


  @doc """
  Updates a box.

  ## Examples

      iex> update_box(box, %{field: new_value})
      {:ok, %Box{}}

      iex> update_box(box, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_box(%Box{} = box, attrs) do
    box
    |> User.Box.changeset(attrs)
    |> Repo.update()
  end

  def put_box_version(%Box{} = box, version) do
    box
    |> change_box
    |> Ecto.Changeset.cast_embed(:versions, box.versions ++ [version])
    |> Ecto.Changeset.put_embed(:versions, box.versions ++ [version])
    |> Ecto.Changeset.put_embed(:current_version, version)
    |> Repo.update()
  end

  def put_box_provider(%Box{} = box, %Version{} = version, provider) do
    new_version = version
    |> change_version
    |> Ecto.Changeset.cast_embed(:providers, version.providers ++ [provider])
    |> Ecto.Changeset.put_embed(:providers, version.providers ++ [provider])
    update_box_version(box, version, new_version)
  end

  def update_box_version(%Box{} = box, old_version, new_version) do
    chain = box.versions
    |> Enum.filter(fn (version) -> Map.get(version, :version) != old_version.version end)

    box
    |> change_box
    |> Ecto.Changeset.cast_embed(:versions, chain ++ [new_version])
    |> Ecto.Changeset.put_embed(:versions, chain ++ [new_version])
    |> put_current_box_version
    |> Repo.update()
  end

  def update_version_provider(%Version{} = version, old_provider, new_provider) do
    chain = version.providers
    |> Enum.filter(fn (provider) -> Map.get(provider, :provider) != old_provider.provider end)

    version
    |> change_version
    |> Ecto.Changeset.cast_embed(:providers, chain ++ [new_provider])
    |> Ecto.Changeset.put_embed(:providers, chain ++ [new_provider])
    |> Repo.update()
  end

  defp put_current_box_version(changeset) do
    with {:ok, insert} <- Ecto.Changeset.fetch_change(changeset, :versions) do
      insert = Enum.at(insert, -1)
      current_version = Ecto.Changeset.fetch_field(changeset, :current_version)
      |> elem(1)
      updated_version = Ecto.Changeset.fetch_field(insert, :version)
      |> elem(1)
      if current_version.version == updated_version == true do
        Ecto.Changeset.put_embed(changeset, :current_version, insert)
      else
        changeset
      end
    else
      _ ->
        changeset
    end
  end


  @doc """
  Deletes a Box.

  ## Examples

      iex> delete_box(box)
      {:ok, %Box{}}

      iex> delete_box(box)
      {:error, %Ecto.Changeset{}}

  """
  def delete_box(%Box{} = box) do
    Repo.delete(box)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking box changes.

  ## Examples

      iex> change_box(box)
      %Ecto.Changeset{source: %Box{}}

  """
  def change_box(%Box{} = box) do
    User.Box.changeset(box, %{})
  end

  @doc """
  Returns the list of version.

  ## Examples

      iex> list_version()
      [%Version{}, ...]

  """
  def list_version do
    Repo.all(Version)
  end

  @doc """
  Gets a single version.

  Raises `Ecto.NoResultsError` if the Version does not exist.

  ## Examples

      iex> get_version!(123)
      %Version{}

      iex> get_version!(456)
      ** (Ecto.NoResultsError)

  """
  #where: fragment("? @> ?", b.versions, ^version_id)
  #where: fragment("(versions_version_index->'version')::jsonb \\? ?", ^version_id)
  #where: b.name == ^box_id and b.username == ^username and fragment("(versions->'version')::text \\? ?", ^version_id)
  #where: b.name == ^box_id and b.username == ^username and fragment("versions @> ?", ^version_id)
  #fragment("(versions->'version')::jsonb \\? ?", ^version_id)
  #fragment("(versions->'version')::jsonb \\? ?", ^version_id)
  #fragment("? @> ?::jsonb", b.versions, ^[version_id])
  #fragment("? @> ?", r.participants, "[{\"role\":\"agent\"}]"
  #fragment("versions @> ?::text::jsonb", ^"[{\"version\":\"#{version_id}\"}]")
  def get_version!(%Box{} = box, version_id) do
    box.versions
    |> Enum.filter(fn (version) -> Map.get(version, :version) == version_id end)
    |> List.first
  end


  @doc """
  Creates a version.

  ## Examples

      iex> create_version(%{field: value})
      {:ok, %Version{}}

      iex> create_version(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_version(attrs \\ %{}) do
    %Version{}
    |> Version.changeset(attrs)
    #|> apply_changes
    |> apply_action(:update)
  end



  @doc """
  Updates a version.

  ## Examples

      iex> update_version(version, %{field: new_value})
      {:ok, %Version{}}

      iex> update_version(version, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_version(%Version{} = version, attrs) do
    version
    |> Version.changeset(attrs)
    #|> apply_action(:update)
  end

  @doc """
  Deletes a Version.

  ## Examples

      iex> delete_version(version)
      {:ok, %Version{}}

      iex> delete_version(version)
      {:error, %Ecto.Changeset{}}

  """
  def delete_version(%Box{} = box, del_version) do
    chain = box.versions
    |> Enum.filter(fn (version) -> Map.get(version, :version) != del_version.version end)

    box
    |> change_box
    |> Ecto.Changeset.put_embed(:versions, chain)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking version changes.

  ## Examples

      iex> change_version(version)
      %Ecto.Changeset{source: %Version{}}

  """
  def change_version(%Version{} = version) do
    Version.changeset(version, %{})
  end




  @doc """
  Returns the list of provider.

  ## Examples

      iex> list_provider()
      [%Provider{}, ...]

  """
  def list_provider do
    Repo.all(Provider)
  end

  @doc """
  Gets a single provider.

  Raises `Ecto.NoResultsError` if the Provider does not exist.

  ## Examples

      iex> get_provider!(123)
      %Provider{}

      iex> get_provider!(456)
      ** (Ecto.NoResultsError)

  """
  def get_provider!(%Box{} = box, version_id, provider_id) do
   box.versions
    |> Enum.filter(fn (version) -> Map.get(version, :version) == version_id end)
    |> List.first
    |> Map.get(:providers)
    |> Enum.filter(fn (provider) -> Map.get(provider, :name) == provider_id end)
    |> List.first
  end

  @doc """
  Creates a provider.

  ## Examples

      iex> create_provider(%{field: value})
      {:ok, %Provider{}}

      iex> create_provider(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_provider(attrs \\ %{}) do
    %Provider{}
    |> Provider.changeset(attrs)
    |> apply_action(:update)
  end

  @doc """
  Updates a provider.

  ## Examples

      iex> update_provider(provider, %{field: new_value})
      {:ok, %Provider{}}

      iex> update_provider(provider, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_provider(%Provider{} = provider, attrs) do
    provider
    |> Provider.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Provider.

  ## Examples

      iex> delete_provider(provider)
      {:ok, %Provider{}}

      iex> delete_provider(provider)
      {:error, %Ecto.Changeset{}}

  """
  def delete_provider(%Provider{} = provider) do
    Repo.delete(provider)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking provider changes.

  ## Examples

      iex> change_provider(provider)
      %Ecto.Changeset{source: %Provider{}}

  """
  def change_provider(%Provider{} = provider) do
    Provider.changeset(provider, %{})
  end

  @doc """
  Returns an upload path for a Provider.

  ## Examples

      iex> upload_provider(provider)
      {:ok, %Provider{}}

      iex> upload_provider(provider)
      {:error, %Ecto.Changeset{}}

  """
  def upload_provider(%Box{} = box, version_id, provider_id) do
    ExAws.Config.new(:s3)
    |> ExAws.S3.presigned_url(:put, "kyozo-store", "#{box.username}/#{box.name}/#{version_id}/#{provider_id}.box")
  end
end
