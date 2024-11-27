#include <gtk/gtk.h>

class HelloWorldApp {
public:
    HelloWorldApp() {
        gtk_init(nullptr, nullptr);

        window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
        gtk_window_set_title(GTK_WINDOW(window), "Hello World");
        gtk_window_set_default_size(GTK_WINDOW(window), 300, 200);

        label = gtk_label_new("Hello, World!");

        gtk_container_add(GTK_CONTAINER(window), label);

        gtk_widget_show_all(window);

        g_signal_connect(window, "destroy", G_CALLBACK(onDestroy), this);
    }

    ~HelloWorldApp() {
        gtk_widget_destroy(window);
    }

    void run() {
        gtk_main();
    }

private:
    static void onDestroy(GtkWidget *widget, gpointer data) {
        gtk_main_quit();
    }

    GtkWidget *window;
    GtkWidget *label;
};

int main(int argc, char *argv[]) {
    HelloWorldApp app;
    app.run();
    return 0;
}

