module Web.View.Static.Welcome where
import Web.View.Prelude

data WelcomeView = WelcomeView

instance View WelcomeView where
    html WelcomeView = [hsx|
         <main class="container mx-auto my-3">
            <a href={pathTo $ RetrosAction} class="m-3 block text-lg bg-blue-500 hover:bg-blue-400 text-white font-bold py-1 px-2 rounded transition duration-300">View your Retro's</a>
         </main>
|]