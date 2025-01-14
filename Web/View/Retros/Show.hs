module Web.View.Retros.Show where
import Web.View.Prelude
import GHC.Base (Semigroup)

data ShowView = ShowView {
    retro :: Retro,
    columns :: [Column],
    items :: [Item],
    comments :: [Comment]
}

instance View ShowView where
    html ShowView { .. } =
        let
            teamId = Just $ get #teamId retro
            retroId = get #id retro
            sortedColumns = columns |> sortOn (get #sortOrder)
            count = length columns
            title = [hsx|
                <div class="bg-gray-700 rounded py-1 px-2">
                    <h1 class="font-bold text-white">{get #title retro}</h1>
                </div>
            |]
            editBtn = [hsx|<a href={pathTo $ EditRetroAction retroId} class="block bg-green-500 hover:bg-green-400 text-white font-bold py-1 px-2 rounded transition duration-300">Edit Retro</a>|]
            nav = renderNavbar teamId title editBtn
        in
        [hsx|
        {nav}
        <main class="w-full flex h-full overflow-x-auto">
            <div class="flex">
                {forEach sortedColumns $ renderColumn items}
                <div style="min-width: 18rem" class="w-72 m-2 rounded">
                    <a href={pathTo $ NewRetroColumnAction retroId count} class="block rounded p-2 text-white bg-gray-800 hover:bg-gray-700 transition duration-300 font-bold">New Column</a>
                </div>
            </div>
        </main>
        |]

renderColumn :: [Item] -> Column ->  Html
renderColumn allItems column =
    let
        retroId = get #retroId column
        columnId = get #id column
        items = allItems
                    |> filter ((== columnId) . get #columnId)
                    |> sortOn (get #sortOrder)
    in
    [hsx|
    <div style="min-width: 18rem" class="p-2 w-72 m-2 rounded bg-gray-800 flex flex-col justify-between">
        <div class="flex justify-between">
            <h2 class="text-2xl text-white font-bold">{get #title column}</h2>
            <div>
                <a href={EditColumnAction columnId} class="bg-green-500 hover:bg-green-400 text-white font-bold py-1 px-2 text-sm rounded transition duration-300">Edit</a>
            </div>
        </div>
        <div class="flex-grow overflow-auto">
            {forEach items renderItem}
        </div>
        <div>
            <a href={NewColumnItemAction retroId columnId $ length items} class="block bg-green-500 hover:bg-green-400 text-white font-bold py-1 px-2 border-b-4 border-green-700 hover:border-green-500 rounded transition duration-300 transform hover:scale-105">+ Add another card</a>
        </div>
    </div>
    |]

renderItem :: Item -> Html
renderItem item =
    [hsx|
        <a href={EditItemAction itemId} class="block rounded shadow text-white bg-gray-700 hover:bg-gray-600 transition duration-200 p-2 my-2">
            {get #title item}
        </a>
    |]
    where
        itemId = get #id item