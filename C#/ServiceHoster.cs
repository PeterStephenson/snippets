        static void Main(string[] args)
        {
            var servicesToRun = new ServiceBase[] { /* Services go here */ };

            if (Environment.UserInteractive)
            {
                var startMethod = typeof(ServiceBase).GetMethod("OnStart", BindingFlags.NonPublic | BindingFlags.Instance);
                var stopMethod = typeof(ServiceBase).GetMethod("OnStop", BindingFlags.NonPublic | BindingFlags.Instance);

                foreach (var service in servicesToRun)
                {
                    startMethod.Invoke(service, new[] { args });
                }

                while (Console.ReadKey().Key != ConsoleKey.Escape) { }

                foreach (var service in servicesToRun)
                {
                    stopMethod.Invoke(service, null);
                }
            }
            else
            {
                ServiceBase.Run(servicesToRun);
            }
        }
    }