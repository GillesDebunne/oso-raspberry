import time
import socket
from subprocess import check_output

from pixel_ring import pixel_ring
from gpiozero import LED


def start():
    pixel_ring.think()


def waiting():
    pixel_ring.speak()


def ok():
    for i in range(4):
        for i in range(31):
            pixel_ring.put(lambda: pixel_ring.set_color(r=0, g=i * 4, b=0))
            time.sleep(0.05)
        for i in range(11):
            pixel_ring.put(lambda: pixel_ring.set_color(r=0, g=120 - i * 12, b=0))
            time.sleep(0.04)


def error():
    for i in range(6):
        pixel_ring.put(lambda: pixel_ring.set_color(r=255, g=0, b=0))
        time.sleep(0.5)
        pixel_ring.off()
        time.sleep(0.2)


def is_connected():
    try:
        # connect to the host -- tells us if the host is actually reachable
        socket.create_connection(("www.google.com", 80))
        return True
    except OSError:
        pass
    return False


def has_ssid():
    ssid = check_output(["iwgetid", "-r"]).decode("utf-8")
    return len(ssid) > 0


if __name__ == "__main__":
    power = LED(5)
    power.on()

    pixel_ring.set_brightness(20)
    pixel_ring.change_pattern("echo")

    try:
        start()
        time.sleep(1)

        if has_ssid():
            if is_connected():
                ok()
            else:
                error()
        else:
            waiting()
            time.sleep(12)
    except KeyboardInterrupt:
        pass

    pixel_ring.off()
    power.off()
    time.sleep(1)

