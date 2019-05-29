from abc import ABC, abstractmethod
from typing import Tuple


class SubTask(ABC):
    def __init__(self, name):
        self.name = name
        super().__init__()

    @abstractmethod
    async def init(self):
        pass

    @abstractmethod
    async def check_for_changes(self) -> Tuple[bool, str]:
        pass

    @abstractmethod
    async def cleanup(self):
        pass